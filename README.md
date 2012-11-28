# itmsp
** CLI for generating app store assets for Game Center and In-App Purchases

Apple recently released their Transporter app (http://bit.ly/UcEhAh) which is a handy way to manage your App Store Packages (.itmsp) instead of having to input achievements, leaderboards, and in-app purchases through iTunes Connect. Unfortunately, there isn't an easy way to generate these packages. Why write XML by hand and deal with the hassle of calculating MD5 and file sizes? Why not define your Game Center and In-App Purchases in a simple format and have your App Store Package generated for you?

## Installation
```sh
$ gem install itmsp
```

## Usage

### Get Familiar With The Spec
First, you'll need to be familiar with the app metadata specification (download from [here](http://bit.ly/TtHMF6)), which outlines all the possible information describing an achievement, leaderboard, or in-app purchase.

### Describe your application metadata
Next, you'll need to create a YAML file describing your company information and achievement, leaderboard, and/or in-app purchase details.

### Generate the .itmsp
This is as simple as running the following command in the folder containing your YAML config file and all referenced images.

```sh
$ itmsp package -i <configuration file>
```

### That's It!
You can now upload your .itmsp package to iTunes Connect using the Transporter tool. Alternatively, there is another great open-source tool which wraps some of the complexities of running Transporter directly (https://github.com/sshaw/itunes_store_transporter)

## Sample Config file
```yaml
provider: test
achivements: 
- name: test
```

## Contact

Colin Humber

- http://github.com/colinhumber
- http://twitter.com/colinhumber

## License

itmsp is available under the MIT license. See the LICENSE file for more info.