# README

## Version

* Ruby - 3.0.3
* Rails - 6.1.4.6
* PostgreSQL - 14.2
* Bootstrap - 3.3.0
* jQuery - 3.6.0

Deployed on Heroku: https://c-e-s.herokuapp.com

## Admin login

- email: admin@ncsu.edu

- password: password

## Various features

First, you should create new instructor or student accounts.

When you log in as an admin, all operations including show all courses, create new course, edit instructors and
students, enrollment managements will show after clicking the 'Admin Management' button at the top middle of the screen.
When filling any form, just follow the placeholer show on the website.

When you log in as an instructor, all operations related to Courses and Enrollments will show after clicking the 'Course
Management' botton at the top middle of the screen. And log in as a student can do their jobs in the same way.

## Handles edge-case scenarios

When an invalid request was made, our web will pop up relative error messages and redirect to the previous page, just
follow the instruction shown in the error messages to make your request valid.

## Test files

[Model test file](test/models/course_test.rb)

[Controller test file](test/controllers/courses_controller_test.rb)
