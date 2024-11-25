from flask import Blueprint, render_template, url_for, session, redirect, request, flash
import mysql.connector

connection = mysql.connector.connect(
    host='localhost',
    user='root',
    password='admin',
    database='site_apostas'
)

cursor = connection.cursor()

home = Blueprint('home', __name__)

@home.route('/')
def index():
    if(session.get('logado')):
        return redirect(url_for('home.pagina_home'))
    else:
        return render_template('index.html')

@home.route('/home')
def pagina_home():
    if(session.get('logado')):
        # Buscar eventos ordenados por data de fim das apostas
        cursor.execute("""
            SELECT id_evento, titulo, descricao, valor_cota, data_evento, 
                   data_inicio_apostas, data_fim_apostas 
            FROM eventos 
            WHERE status = 'Aprovado' 
            ORDER BY data_fim_apostas ASC
        """)
        eventos_proximos_fim = cursor.fetchall()

        # Buscar eventos ordenados por número de apostas
        cursor.execute("""
            SELECT e.id_evento, e.titulo, e.descricao, e.valor_cota, e.data_evento, 
                   e.data_inicio_apostas, e.data_fim_apostas, COUNT(a.id_evento) as total_apostas
            FROM eventos e
            LEFT JOIN apostas a ON e.id_evento = a.id_evento
            WHERE e.status = 'Aprovado'
            GROUP BY e.id_evento, e.titulo, e.descricao, e.valor_cota, e.data_evento, 
                     e.data_inicio_apostas, e.data_fim_apostas
            ORDER BY total_apostas DESC
        """)
        eventos_populares = cursor.fetchall()

        return render_template('home.html', 
                            nome=session.get('nome'),
                            eventos_proximos_fim=eventos_proximos_fim,
                            eventos_populares=eventos_populares)
    else:
        return redirect(url_for('home.index'))
    
@home.route('/moderador', methods=['GET', 'POST'])
def pagina_moderador():
    if session.get('email') != 'moderador@4bets.com':
        return redirect(url_for('home.pagina_home'))
    
    if request.method == 'POST':
        evento_id = request.form.get('evento_id')
        acao = request.form.get('acao')
        
        if acao == 'aprovar':
            novo_status = 'Aprovado'
        else:
            novo_status = 'Rejeitado'
        
        cursor.execute("""
            UPDATE eventos 
            SET status = %s 
            WHERE id_evento = %s
        """, (novo_status, evento_id))
        
        connection.commit()
        return redirect(url_for('home.pagina_moderador'))
    
    cursor.execute("""
        SELECT id_evento, titulo, descricao, valor_cota, data_evento, 
               data_inicio_apostas, data_fim_apostas 
        FROM eventos 
        WHERE status = 'Pendente'
        ORDER BY data_evento
    """)
    eventos = cursor.fetchall()
    connection.commit()
    return render_template('moderador.html', eventos=eventos)

@home.route('/finalizar_eventos', methods=['GET', 'POST'])
def finalizar_eventos():
    if session.get('email') != 'moderador@4bets.com':
        return redirect(url_for('home.pagina_home'))
    
    # Buscar eventos aprovados que já passaram da data
    cursor.execute("""
        SELECT id_evento, titulo, descricao, data_evento 
        FROM eventos 
        WHERE status = 'Aprovado' 
        AND data_evento < CURDATE()
        AND resultado IS NULL
        ORDER BY data_evento DESC
    """)
    eventos = cursor.fetchall()
    
    if request.method == 'POST':
        evento_id = request.form.get('evento_id')
        resultado = request.form.get('resultado')
        
        # Buscar a cota do evento
        cursor.execute("""
            SELECT valor_cota 
            FROM eventos 
            WHERE id_evento = %s
        """, (evento_id,))
        valor_cota = float(cursor.fetchone()[0])
        
        # Atualizar o resultado do evento
        cursor.execute("""
            UPDATE eventos 
            SET resultado = %s, status = 'Finalizado'
            WHERE id_evento = %s
        """, (resultado, evento_id))
        
        # Buscar todas as apostas do evento
        cursor.execute("""
            SELECT id_usuario, valor_aposta, resultado_esperado 
            FROM apostas 
            WHERE id_evento = %s
        """, (evento_id,))
        apostas = cursor.fetchall()
        
        # Calcular o total perdido e o total apostado pelos vencedores
        total_perdido = sum(float(aposta[1]) for aposta in apostas if aposta[2] != resultado)
        total_apostado_vencedores = sum(float(aposta[1]) for aposta in apostas if aposta[2] == resultado)
        
        # Distribuir os ganhos para os vencedores
        for aposta in apostas:
            if aposta[2] == resultado:  # Se acertou o resultado
                valor_apostado = float(aposta[1])
                
                # Ganho da cota (valor apostado * cota)
                ganho_cota = valor_apostado * valor_cota
                
                # Ganho proporcional dos perdedores
                if total_apostado_vencedores > 0:
                    proporcao = valor_apostado / total_apostado_vencedores
                    ganho_perdedores = total_perdido * proporcao
                else:
                    ganho_perdedores = 0
                
                # Ganho total (ganho da cota + ganho dos perdedores)
                ganho_total = ganho_cota + ganho_perdedores
                
                print(f"Debug - Usuário {aposta[0]}: Valor apostado: {valor_apostado}, Ganho cota: {ganho_cota}, Ganho perdedores: {ganho_perdedores}, Total: {ganho_total}")  # Debug
                
                # Atualiza o saldo do usuário
                cursor.execute("""
                    UPDATE usuario 
                    SET saldo = saldo + %s 
                    WHERE idusuario = %s
                """, (ganho_total, aposta[0]))
        
        connection.commit()
        flash('Evento finalizado e ganhos distribuídos com sucesso!', category='sucesso')
        return redirect(url_for('home.finalizar_eventos'))
    
    return render_template('finalizar_eventos.html', eventos=eventos)

