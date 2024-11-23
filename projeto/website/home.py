from flask import Blueprint, render_template, url_for, session, redirect, request
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
        cursor.execute("""
            SELECT id_evento, titulo, descricao, valor_cota, data_evento, 
                   data_inicio_apostas, data_fim_apostas 
            FROM eventos 
            WHERE status = 'Aprovado'
            ORDER BY data_evento
        """)
        eventos = cursor.fetchall()
        return render_template('home.html', nome=session.get('nome'), eventos=eventos)
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

