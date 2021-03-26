# DevOps Engineer

Dear Candidate,

First, we are happy you get this far on our hiring process, congratulations. We believe that interviews are probably not the best place to test the skills of a promising candidate. We created this little challenge for you to show your skills. We hope you enjoy it as much as we did.

This little challenge was created in a way to give you maximum freedom so that you can show us the best of your expertise. Roughly you have up to two weeks to send it in.

## Part 1

This test is made to know more each candidate to our DevOps Engineer position. This is not an objective test which aims at generating a score, but a study case to learn more about the knowledge, experiences and the way that you work. Feel free to develop your solution for the problem and, if you have any question, don't hesitate in contacting us.

Inside the `app` directory there is a very simple Flask application. Once this app starts it reads an environment variable called `APP_SECRET_TOKEN` that is the API password. Hence, any call to the application needs an `Authorization` header with a specific token. Eg: `curl -H "Authorization: Token SomeSecretToken" http://localhost:8000/`. You should tell us how to define/change this token in an easy way.

Your goal is to deploy this application in AWS (Amazon Web Service). Probably, you'll need to create a free-tier AWS account, or use an already created account, but don't worry about it, **we won't look at your account or call the application already running**. We want to be able to recreate all this infrastructure in our account as simply as possible. Be creative.

Feel free to change the code of the application if you need it.

_Note: Place your code in the `part-1` directory._

## Part 2

This test aims at understanding your knowledge about AWS scenarios. We want to know if you know AWS and it products and how this products talk to each other.

Look at the following diagram and, write a technical description about this topology.

_Note: Place your writing in the `part-2` directory._

![part-2-aws-test-scenario](part-2/diagram.png)

