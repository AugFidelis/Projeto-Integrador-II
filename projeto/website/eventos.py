from flask import Blueprint, render_template, request, flash, redirect, url_for, session
import mysql.connector
from datetime import datetime

connection = mysql.connector.connect(
    host='localhost',
    user='root',
    password='admin',
    database='site_apostas'
)

cursor = connection.cursor()

eventos = Blueprint('eventos', __name__)

@eventos.route('/criar_evento', methods=['GET', 'POST'])
def criar_evento():
    if not session.get('logado'):
        return redirect(url_for('auth.login'))
        
    if request.method == 'POST':
        titulo = request.form.get('titulo')
        descricao = request.form.get('descricao')
        valor_minimo = float(request.form.get('valor_minimo'))
        data_evento = request.form.get('data_evento')
        data_inicio = request.form.get('data_inicio')
        data_fim = request.form.get('data_fim')
        
        # Obter o ID do usuário atual
        email = session.get('email')
        cursor.execute("SELECT idusuario FROM usuario WHERE email = %s", (email,))
        id_usuario = cursor.fetchone()[0]
        
        # Inserir o evento no banco de dados
        cursor.execute("""
            INSERT INTO eventos (titulo, descricao, valor_cota, data_evento, 
            data_inicio_apostas, data_fim_apostas, id_usuario_criador)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (titulo, descricao, valor_minimo, data_evento, data_inicio, 
              data_fim, id_usuario))
        
        connection.commit()
        flash('Evento criado com sucesso!', category='sucesso')
        return redirect(url_for('home.pagina_home'))
    
    return render_template('criar_evento.html')

@eventos.route('/apostar/<int:evento_id>', methods=['GET', 'POST']) #<int:evento_id> é o id do evento que aparece na url
def apostar(evento_id):
    if not session.get('logado'):
        return redirect(url_for('auth.login'))
    
    # Buscar informações do evento
    cursor.execute("""
        SELECT titulo, descricao, valor_cota, data_evento, 
        data_inicio_apostas, data_fim_apostas 
        FROM eventos WHERE id_evento = %s
    """, (evento_id,))
    evento = cursor.fetchone()
    
    if request.method == 'POST':
        resultado = 'Sim' if request.form.get('resultado') == 'Acontecerá' else 'Não'
        valor_aposta = float(request.form.get('valor_aposta'))
        
        # Obter o ID do usuário atual
        email = session.get('email')
        cursor.execute("SELECT idusuario FROM usuario WHERE email = %s", (email,))
        id_usuario = cursor.fetchone()[0]
        
        # Inserir a aposta no banco de dados
        cursor.execute("""
            INSERT INTO apostas (resultado_esperado, valor_aposta, data_aposta, 
            id_usuario, id_evento)
            VALUES (%s, %s, NOW(), %s, %s)
        """, (resultado, valor_aposta, id_usuario, evento_id))
        
        connection.commit()
        flash('Aposta realizada com sucesso!', category='sucesso')
        return redirect(url_for('home.pagina_home'))
    
    return render_template('aposta.html', evento=evento)
