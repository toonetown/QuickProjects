## Quick Project Templates ##

This project will create a shared Visual Studio / Xcode project files based off the templates in this directory.

Any symbolic links that you want copied (i.e. `third_party`) should be absolute paths so the copy works correctly.

_Note:_ The Boost library is already included in the project files, but no other third party libraries are included.


### Setup ###

Run the `deploy.sh` script to deploy to a new project.  The target location must **NOT** exist, but the parent directory of the target location **MUST** exist.


### Creating Projects ###

##### Visual Studio #####

 1.  Create new project (empty)
 2.  Change the `x86` configuration to `Win32`
 3.  Add the `defaults` property pages
     - Add architecture-specific ones first, then Debug/Release, then the common one last
 4.  Add link libraries to `Linker | Input | Additional Dependencies` as `libmy_library$(THIRD_PARTY_LIBEXT)`


##### Xcode #####

 1.  Create new target (library or command line)
 2.  Remove everything except `Product Name`
 3.  Add link libraries to `Other Linker Flags` as `-lmy_library`

