# License Scanner UI

**Description**: Monitoring and license curation web user interface for the 
[License Scanner service](https://github.com/philips-software/license-scanner).

The project is developed in Flutter using the Dart programming language.

## Dependencies

This project provides the user interface for the [License Scanner 
service](https://github.com/philips-software/license-scanner) project.

## Installation

Build the application for web:
```bash
flutter build web
```

This generates the app in the `/build/web` directory of this project,
which can be copied directly into the `src/main/resources/static`
folder of the License Scanner.

## Configuration

If the software is configurable, describe it in detail, either here or in other documentation to which you link.

## Usage

**Stand-alone**:
The user interface can run as a stand-alone (desktop) app for 
development: Follow the appropriate [Flutter desktop](https://flutter.dev/desktop) 
instructions to configure your system for building native desktop
applications, and start it either from the command line or your IDE.

**In browser**:
To integrate the client as a Progressive Web Application in the 
Scanner Service, first follow the [Flutter web](https://flutter.dev/web) 
instructions to set up your system for building web applications. 
You should be able to run the application this way from your IDE, 
which will silently take care of the required CORS handling.

## How to test the software

(The project does not include any tests.)

## Known issues

(Empty)

## Contact / Getting help

Use the project issue tracker.

## License

See [LICENSE.md](LICENSE.md).

## Credits and references

(Empty)

