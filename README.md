# LinkedIn-Oauth2
Example of linkedIn Oauth2 written in Swift 4

Regarding the OAuth 2.0 protocol there are no much to say, as the best move here would be to prompt you to read about it in the official website. In short, here are the steps that we’ll follow in this tutorial for a successful sign in and authorization process:

> **Note:**
> - Necessarily, we are going to create a new app in the  [LinkedIn developer portal][1]. That will let us get two important keys (Client ID and Client Secret) required for the rest of the process.
> - Using a web view, we’ll let user sign in to his LinkedIn account.
> - Using the above, plus some more pieces of required data, we’ll ask the LinkedIn server for an authorization code.
> - We’ll exchange the authorization code with an access token.

More info about useful info from LinkedIn [here][2]
Integrating step by step instruction [here][3]

## Support 
Please start if example usefull for you.

[1]:https://developer.linkedin.com/
[2]:https://developer.linkedin.com/docs/signin-with-linkedin
[3]:https://www.appcoda.com/linkedin-sign-in/
