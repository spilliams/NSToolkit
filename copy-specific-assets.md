This README outlines how to set up client-specific assets for your OS X application. What does that mean? Well, let's say you have an app that will be delivered to multiple clients, and they each want their own images and copy in it.

#File Structure

1. First, add a directory to your project. Name it "Client-Specific Assets" or similar.
2. Within that directory, make a sub-directory for each client. In this example I'll be using "A" and "B" as my clients.

Your file structure is ready!

#Targets & Build Settings

Presumably you already have a build target for the app. This will end up as the build target for one of the clients. Don't duplicate it yet, we're going to make a couple of changes to its build settings to reduce legwork later.

1. Change the build setting for "Installation Build Products Location" to `/tmp/$(PROJECT_NAME)-$(PRODUCT_NAME).dst`.
2. Change the build setting for "Product Name" to `$(TARGET_NAME)`.
3. Ok, now duplicate that target until you have as many targets as clients.
4. Rename the targets so you can differentiate them. It's **vital** that the target names match the directory names from before!

#Images & Copy

Why did we create directories for each client? Why not just throw all of the files into the same project directory like we do with everything else in Cocoa? Because these files will have identical names.

1. First, make a new group in your project structure. call it (for example) "client assets".
2. Within that group make a group for each of your clients.
3. Within each client group make a file named "Copy.strings".
    - If you make this file with Xcode, make sure the correct client's target is selected in the New File dialog.
    - If you make this file with `touch` or a text editor, add it to the Xcode project and make sure to select the correct client's target.
4. Within each client directory make a file named "Images.xcassets". You probably have to make this with Xcode. As of this writing, that means selecting `File > New > File...` and in the New File dialog selecting `OS X > Resource > Asset Catalog`. To save time, you can duplicate the first one you make so you don't have to go through this dialog so many times.
3. Go over the project structure one more time, making sure that all Copy and Images files are imported, and where they need to be in the group hierarchy. Also make sure each one is only included in its client's build target.

#Using the assets

##Key Naming

So, how do you use these assets? Well, as of this writing there's a bit of a catch: Every key used in an Images or Copy file needs to be identical across all of the Images or Copy files. So let's say you have a spot in one of your storyboards for an image named `hero_4` (note there's no file extension). That means that within **each** of your Images.xcassets files you need to have an image set named `hero_4` (even if the set is empty). Similarly, if you wanted to include a copy string described by the key "privacy-policy", then **each** of your Copy.strings files needs to include that key (even if its value is an empty string).

##Images

As I mentioned just now, you can use your Images keys in Interface Builder (in fact, if you set up the key in the xcassets files before adding the image view to your storyboard/nib then the Image field will autocomplete!). You can also use these images in code with something like `[NSImage imageNamed:@"hero_4"]`.

##Strings

To add strings, each Copy.strings file should get a line like this:

    "privacy-policy" = "This here is the privacy policy: What's privacy?";

Then you can retrieve that string in code with

    NSLocalizedStringFromTable(@"privacy-policy", @"Copy", nil)

Or, if you want to get fancy, you can define a helper macro for it:

    #define Copy(c) NSLocalizedStringFromTable(c, @"Copy", nil)

And retrieving is much more readable!

    Copy(@"privacy-policy")

(Personally, I put this macro and others like it in a `Constants.h` file, then import that file into any class that needs to use it)

#Plist

Ok, I went through all of that without mentioning the Info.plist file. I assume the above works. I haven't tried just doing those steps though, I also split my Info.plist file between clients. In case Xcode is complaining about Info.plist, you may have to do some more steps:

1. move your Info.plist file into the first client directory.
2. In my case, I chose to edit the Bundle Identifier to `com.mycompanyidentifier.$(PROJECT_NAME)-$(PRODUCT_NAME:rfc1034identifier)`.
3. duplicate that plist into each other client directory.
4. Add the new plists to your app, but only for the proper target.
5. For each target, change the build setting for "Info.plist File" to `"MyProject/Client-Specific Assets/$(PRODUCT_NAME)/Info.plist"`
