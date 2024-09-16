# This is a sample Python script.

# Press ⌃R to execute it or replace it with your code.
# Press Double ⇧ to search everywhere for classes, files, tool windows, actions, and settings.

import psycopg2

from flask import Flask, render_template, request, redirect, url_for
from gevent.pywsgi import WSGIServer

dest = "dbname=postgres user=postgres  password=password"
conn = psycopg2.connect(dest)

app = Flask(__name__)
global employeeId
global epassword


@app.route('/')
def index():
    return render_template('applicationSelect.html')


@app.route('/hrLogin')
def hrLogin():
    return render_template('hrLogin.html')


@app.route('/projLogin')
def projLogin():
    return render_template('projLogin.html')


@app.route('/logout')
def logout():
    return render_template('applicationSelect.html')


@app.route('/checkLogin', methods=['POST', 'GET'])
def loginHR():
    text = "Credentials doesn't match"
    if request.method == 'POST':
        employeeId = request.form['inputEmployeeID']
        epassword = request.form['inputPassword']
        displayContent = []
        hourlySal = []
        salarySal = []

        cursor = conn.cursor()
        stat = "SELECT * FROM Credentials WHERE employee = %s and password = %s"
        values = [employeeId, epassword]
        cursor.execute(stat, tuple(values))
        data = cursor.fetchone()

        if data is None:
            # if a user enters wrong password return it to the login page
            return render_template('hrLogin.html', text=text)
        else:
            cursor = conn.cursor()
            stat = "SELECT * FROM employee WHERE employeenum = %s"
            values = [employeeId]
            cursor.execute(stat, tuple(values))
            data = cursor.fetchone()

            for i in range(len(data)):
                displayContent.append(data[i])

            stat = "SELECT S.hourly, S.empid, E.ename from salary AS S," \
                   " employee AS E where S.hourly IS NOT NULL AND (S.empid = E.employeenum);"
            cursor.execute(stat, tuple(values))
            hourlySal = cursor.fetchall()

            stat = "SELECT S.hourly, S.empid, E.ename from salary AS S," \
                   " employee AS E where S.hourly IS NOT NULL AND (S.empid = E.employeenum);"
            cursor.execute(stat)
            hourlySal = cursor.fetchall()

            stat = "SELECT S.salary, S.empid, E.ename from salary AS S," \
                   " employee AS E where S.salary IS NOT NULL AND (S.empid = E.employeenum);"
            cursor.execute(stat)
            salarySal = cursor.fetchall()

            return render_template('WelcomeHR.html', ID=displayContent[0], name=displayContent[1],
                                   jobTitle=displayContent[3], officenum=displayContent[4], phoneNum=displayContent[5],
                                   hourly=hourlySal, salary=salarySal)


@app.route('/showTrans', methods=['POST', 'GET'])
def showTransactions():
    cursor = conn.cursor()
    allTrasactions = []
    stat = "SELECT * from transactions;"
    cursor.execute(stat)
    allTrasactions = cursor.fetchall()
    tempSalary = 0
    allTrasactions2 = []
    for i in range(len(allTrasactions)):
        temptuple = allTrasactions[i]
        templist = list(temptuple)
        tempSalary = allTrasactions[i][2]
        federal = round(tempSalary * 0.10, 2)
        stateTax = round(tempSalary * 0.05, 2)
        OtherTax = round(tempSalary * 0.03, 2)
        takeHome = round(tempSalary - federal - stateTax - OtherTax, 2)
        templist.append(federal)
        templist.append(stateTax)
        templist.append(OtherTax)
        templist.append(takeHome)
        temptuple2 = tuple(templist)
        allTrasactions2.append(temptuple2)

    return render_template('showTransactions.html', trans=allTrasactions2)


@app.route('/checkloginMang', methods=['POST', 'GET'])
def loginMang():
    text = "Credentials doesn't match"
    displayContent = []

    if request.method == 'POST':
        employeeId = request.form['inputEmployeeID']
        epassword = request.form['inputPassword']

        cursor = conn.cursor()
        stat = "SELECT * FROM Credentials WHERE employee = %s and password = %s"
        values = [employeeId, epassword]
        cursor.execute(stat, tuple(values))
        data = cursor.fetchone()

        if data is None:
            # if a user enters wrong password return it to the login page
            return render_template('projLogin.html', text=text)
        else:
            cursor = conn.cursor()
            stat = "SELECT * FROM employee WHERE employeenum = %s"
            values = [employeeId]
            cursor.execute(stat, tuple(values))
            data = cursor.fetchone()
            for i in range(len(data)):
                displayContent.append(data[i])

            return render_template('WelcomeManag.html', ID=displayContent[0], name=displayContent[1],
                                   jobTitle=displayContent[3], officenum=displayContent[4], phoneNum=displayContent[5])


@app.route('/createProject', methods=['POST', 'GET'])
def createProjectPage():
    cursor = conn.cursor()
    stat = "SELECT depname from department"
    cursor.execute(stat)
    departments = cursor.fetchall()
    displaytupledep = []
    projectmembs = []

    for i in range(len(departments)):
        displaytupledep.append(departments[i][0])

    stat = "SELECT ename from employee where employeenum NOT IN (SELECT manager from project);"
    cursor.execute(stat)
    managers = cursor.fetchall()
    displaytupleman = []
    for i in range(len(managers)):
        displaytupleman.append(managers[i][0])

    stat = "SELECT ename from employee where projectnum IS NULL;"
    cursor.execute(stat)
    data = cursor.fetchall()
    for i in range(len(data)):
        projectmembs.append(data[i][0])

    print(displaytupledep)
    print(projectmembs)

    return render_template('createproj.html', dispDepart=tuple(displaytupledep), dispMang=tuple(displaytupleman)
                           , dispMembs=tuple(projectmembs))


@app.route('/viewMilestones', methods=['POST', 'GET'])
def viewMileStones():
    cursor = conn.cursor()
    stat = "select * from milestones order by projectnum;"
    cursor.execute(stat)
    milestones = cursor.fetchall()

    print(milestones)
    return render_template('viewMileStones.html', dispmilestone=milestones)


@app.route('/viewStats', methods=['POST', 'GET'])
def viewStatistics():
    cursor = conn.cursor()
    stat = "select COUNT(*), projectnum from employee where projectnum IS NOT NULL group by projectnum;"
    cursor.execute(stat)
    emps = cursor.fetchall()

    stat = "select ROUND(AVG(projbudget),2) from project;"
    cursor.execute(stat)
    avg = cursor.fetchall()

    return render_template('viewStatistics.html', dispEmps=emps, dispAvg=avg)


# Press the green button in the gutter to run the script.


if __name__ == '__main__':
    app.run()

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
