from flask import Blueprint, render_template, url_for, session, redirect

home = Blueprint('home', __name__)

@home.route('/')
def index():
    if(session.get('logado')):
        return redirect(url_for('home.pagina_home'))
    else:
        return render_template('index.html')

@home.route('/home')
def pagina_home():
    if(session.get('logado')): # Verifica se o usuario está logado, caso não estiver, redireciona para a pagina deslogada
        return render_template('home.html', nome=session.get('nome'))
    else:
        return redirect(url_for('home.index'))

