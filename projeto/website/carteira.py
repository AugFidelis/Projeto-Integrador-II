from flask import Blueprint, render_template, url_for, session, request, flash, redirect
import mysql.connector
from datetime import datetime

connection = mysql.connector.connect(
    host='localhost',
    user='root',
    password='admin',
    database='site_apostas'
)

cursor = connection.cursor()

carteira = Blueprint('carteira', __name__)

@carteira.route('/')
def paginacarteira():
    email = session.get('email')
    
    # Atualizar saldo da sessão com o valor atual do banco de dados
    cursor.execute("SELECT saldo FROM usuario WHERE email = %s", (email,))
    saldo_atual = float(cursor.fetchone()[0])
    session['saldo'] = saldo_atual
    
    # Buscar transações
    cursor.execute("""
        SELECT t.valor_transacao, t.meio_pagamento, t.data_transacao 
        FROM transacoes t
        JOIN usuario u ON t.idusuario = u.idusuario
        WHERE u.email = %s AND t.valor_transacao > 0
        ORDER BY t.data_transacao DESC
    """, (email,))
    
    transacoes = cursor.fetchall()

    # Buscar histórico de apostas
    cursor.execute("""
        SELECT a.valor_aposta, e.titulo, a.resultado_esperado, a.data_aposta
        FROM apostas a
        JOIN usuario u ON a.id_usuario = u.idusuario
        JOIN eventos e ON a.id_evento = e.id_evento
        WHERE u.email = %s
        ORDER BY a.data_aposta DESC
    """, (email,))
    
    apostas = cursor.fetchall()
    
    # Forçar commit para garantir dados atualizados
    connection.commit()
    
    return render_template('carteira.html', saldo=session.get('saldo'), 
                         transacoes=transacoes, apostas=apostas)

@carteira.route('/compra', methods=['GET', 'POST'])
def compra():
    if request.method == 'POST':
        # Convert session saldo to float before adding
        valor = float(request.form.get('valor'))
        novo_saldo = float(session.get('saldo', 0)) + valor
        
        # Atualizar saldo do usuário
        email = session.get('email')
        cursor.execute("UPDATE usuario SET saldo = %s WHERE email = %s", (novo_saldo, email))
        
        # Registrar transação
        cursor.execute("""
            INSERT INTO transacoes (valor_transacao, meio_pagamento, data_transacao, idusuario)
            SELECT %s, 'Cartão de Crédito', %s, idusuario
            FROM usuario
            WHERE email = %s
        """, (valor, datetime.now(), email))
        
        connection.commit()
        
        # Atualizar saldo na sessão
        session['saldo'] = novo_saldo
        
        flash('Créditos adicionados com sucesso!', category='sucesso')
        return redirect(url_for('carteira.paginacarteira'))
        
    return render_template('compra.html')

@carteira.route('/sacar_saldo', methods=['GET', 'POST'])
def sacar_saldo():
    if request.method == 'POST':
        valor = float(request.form.get('valor'))
        tipo = request.form.get('resposta')

        # Verifica limite máximo de saque
        if valor > 101000:
            flash('O valor máximo de saque permitido é R$ 101.000,00', category='erro')
            return redirect(url_for('carteira.sacar_saldo'))

        # Calcula taxa de saque
        if valor <= 100:
            taxa = valor * 0.04
        elif valor <= 1000:
            taxa = valor * 0.03
        elif valor <= 5000:
            taxa = valor * 0.02
        elif valor <= 100000:
            taxa = valor * 0.01
        else:
            taxa = 0

        valor_total = valor - taxa  # Valor que o usuário receberá com a taxa descontada
        
        # Verifica se há saldo suficiente
        if valor > session.get('saldo'):
            flash('Saldo insuficiente para realizar o saque', category='erro')
            return redirect(url_for('carteira.sacar_saldo'))
    
        email = session.get('email')
        novo_saldo = session.get('saldo') - valor
        cursor.execute("UPDATE usuario SET saldo = %s WHERE email = %s", (novo_saldo, email))
        
        if tipo == 'conta_bancaria':
            cursor.execute("""
                INSERT INTO transacoes (valor_transacao, meio_pagamento, data_transacao, idusuario)
                SELECT %s, 'Transferência Bancária', %s, idusuario
                FROM usuario
                WHERE email = %s
            """, (-valor_total, datetime.now(), email))
        elif tipo == 'pix':
            cursor.execute("""
                INSERT INTO transacoes (valor_transacao, meio_pagamento, data_transacao, idusuario)
                SELECT %s, 'PIX', %s, idusuario
                FROM usuario
                WHERE email = %s
            """, (-valor_total, datetime.now(), email))
        
        connection.commit()
        session['saldo'] = novo_saldo
        
        flash(f'Saque de R$ {valor_total:.2f} realizado com sucesso! Taxa cobrada: R$ {taxa:.2f}', category='sucesso')
        return redirect(url_for('carteira.paginacarteira'))
    
    return render_template('sacar_saldo.html')
