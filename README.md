# UI for License Scanner

This is a user interface for the [License Scanner 
service](https://github.com/philips-labs/license-scanner).

## Build instructions

### Stand-alone
The user interface can run as a stand-alone (desktop) app for 
development: Follow the appropriate [Flutter desktop](https://flutter.dev/desktop) 
instructions to configure your system for building native desktop
applications, and start it either from the command line or your IDE.

### Embedding web application into Scanner Service
To integrate the client as a Progressive Web Application in the 
Scanner Service, first follow the [Flutter web](https://flutter.dev/web) 
instructions to set up your system for building web applications. 
You should be able to run the application this way from your IDE, 
which will silently take care of the required CORS handling.

Build the application for web:
```bash
flutter build web
```

This generates the app in the `/build/web` directory of this project,
which can be copied directly into the `src/main/resources/static`
folder of the License Scanner.

