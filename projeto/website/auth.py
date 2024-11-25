from flask import Blueprint, render_template, url_for, request, flash, redirect, session
import mysql.connector

connection = mysql.connector.connect(
    host='localhost',
    user='root',
    password='admin',
    database='site_apostas'
)

cursor = connection.cursor()

auth = Blueprint('auth', __name__)

@auth.route('/login', methods=['GET', 'POST'])
def login():
    msg = ''
    if(request.method == 'POST'):
        email = request.form.get('email')
        senha = request.form.get('senha')

        cursor.execute("SELECT * FROM usuario WHERE email = %s AND senha = %s", (email, senha))
        user = cursor.fetchone()

        if(user):
            session['logado'] = True
            session['email'] = email
            session['nome'] = user[1]
            session['data_nascimento'] = user[4]
            session['saldo'] = float(user[5])
            return redirect(url_for('home.pagina_home'))
        else:
            msg = 'Email ou senha inválidos!'

    return render_template('login.html', msg=msg)

@auth.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('home.index'))

@auth.route('/cadastro', methods=['GET', 'POST'])
def cadastro():
    if(request.method == 'POST'):
        email = request.form.get('email')
        nome = request.form.get('nome')
        data_nascimento = request.form.get('data_nascimento')
        senha1 = request.form.get('senha1')
        senha2 = request.form.get('senha2')

        cursor.execute("SELECT * FROM usuario WHERE email = %s", (email,)) # Verifica se o email já está cadastrado 
        user = cursor.fetchone() # Retorna o usuario se ele existir

        if(user):
            flash('Email já cadastrado!', category='erro')
        elif(len(email) < 4):
            flash('Email deve ter mais que 4 caracteres!', category='erro')
        elif(senha1 != senha2):
            flash('As senhas não são iguais!', category='erro')
        elif(len(senha1) < 7):
            flash('Senha deve ter mais que 7 caracteres!', category='erro')
        else:
            # adicionar usuario pro banco de dados
            cursor.execute("INSERT INTO usuario (email, senha, nome, data_nascimento) VALUES (%s, %s, %s, %s)", (email, senha1, nome, data_nascimento))
            connection.commit()
            
            # Fazer login automático
            session['logado'] = True
            session['email'] = email
            session['nome'] = nome
            session['data_nascimento'] = data_nascimento
            session['saldo'] = 0.0  # Saldo inicial
            
            return redirect(url_for('auth.credito_inicial'))

    return render_template('cadastro.html')

@auth.route('/credito-inicial', methods=['GET', 'POST'])
def credito_inicial():
    if not session.get('logado'):
        return redirect(url_for('auth.login'))
    
    if request.method == 'POST':
        if request.form.get('deposito_inicial') == 'sim':
            return redirect(url_for('carteira.compra'))
        else:
            return redirect(url_for('home.pagina_home'))

    return render_template('credito_inicial.html')
