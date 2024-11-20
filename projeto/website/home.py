from flask import Blueprint, render_template, url_for, session, redirect

home = Blueprint('home', __name__)

@home.route('/')
def index():
    return render_template('index.html')

@home.route('/home')
def pagina_home():
    if(session.get('logado')): # Verifica se o usuario está logado, caso não estiver, redireciona para a pagina deslogada
        return render_template('home.html', nome=session.get('nome'))
    else:
        return redirect(url_for('home.index'))

@home.route('/criar_evento')
def criar_evento():
    return render_template('criar_evento.html')

@home.route('/apostar')
def apostar():
    return render_template('aposta.html')
