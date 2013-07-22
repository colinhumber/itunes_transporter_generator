# itunes_transporter_generator [![Gem Version](https://badge.fury.io/rb/itunes_transporter_generator.png)](http://badge.fury.io/rb/itunes_transporter_generator)
**CLI for generating and packaging app store assets for Game Center and In-App Purchases**

Apple recently released their Transporter app (http://bit.ly/UcEhAh) which is a handy way to manage your App Store Packages (.itmsp) instead of having to input achievements, leaderboards, and in-app purchases through iTunes Connect. Unfortunately, there isn't an easy way to generate these packages. Why write XML by hand and deal with the hassle of calculating MD5 and file sizes? Why not define your Game Center and In-App Purchases in a simple format and have your App Store Package generated for you?

## Installation
```sh
$ gem install itunes_transporter_generator
```

## Usage

### Get familiar with the spec
First, you'll need to be familiar with the app metadata specification, available from the bottom navigation in the Manage Your Applications section of iTunes Connect, which outlines all the possible information describing an achievement, leaderboard, or in-app purchase.

### Describe your application metadata
Next, you'll need to create a YAML file describing your company information and achievement, leaderboard, and/or in-app purchase details. The beauty of describing your app store assets in YAML is no hand writing XML making it understandable at a glance, and you can store your configuration in source control.

### Generate the .itmsp
This is as simple as running the following command in the folder containing your YAML config file and all referenced images.

```sh
$ itmsp package -i <configuration file>
```

### That's It!
You can now upload your .itmsp package to iTunes Connect using the Transporter tool. Alternatively, there is another great open-source tool which wraps some of the complexities of running Transporter directly (https://github.com/sshaw/itunes_store_transporter)

## Sample Config file
Below is a sample configuration file describing an achievement, leaderboard, and in-app purchase. The specific metadata required for each item type is fully described in the [App Metadata Specification guide](http://bit.ly/TtHMF6)

```yaml
provider: SampleCompany # optional if team_id is supplied
team_id: ABCDE12345 # optional if provider is supplied
vendor_id: sample sku # the application's SKU as defined in iTunes Connect 
id_prefix: com.samplecompany.applicationname. # if supplied, this will be prefixed to achievement, leaderboard, and in-app purchase IDs
versions:
  - name: 1.1.3.1
    locales:
      - name: en-US
        title: sampleApp
        description: Description of sampleApp.
        keywords:
          - Sample
          - App
        version_whats_new: Version Whats New.
        software_url: 'http://example.com'
        privacy_url: 'http://example.com'
        support_url: 'http://example.com'
        screenshots:
          - display_target: 'iOS-3.5-in'
            file_name: 'test.jpg'

achievements: # the order in which achievements are defined will be the order in which they appear in Game Center
- id: first_achievement
  name: First Achievement
  points: 10
  locales:
    - name: en
      title: First Achievement
      before_earned_description: Complete a task
      after_earned_description: Completed a task
      achievement_after_earned_image: test.jpg

leaderboards: # the order in which leaderboards are defined will be the order in which they appear in Game Center
- default: true # only one leaderboard can be set as default. 
  id: top_scores
  name: Top Scores
  locales:
    - name: en
      title: Top Scores
      formatter_suffix: ' Points' # note the space. This must be provided if you want a space between the value and suffix
      formatter_suffix_singular: ' Point'
      formatter_type: INTEGER_COMMA_SEPARATOR
      leaderboard_image: test.jpg

purchases:
  auto_renewable_purchases:
    family:
      name: Sample Product Group
      review_screenshot_image: test.jpg
      purchases:
        - product_id: six_month_subscription
          type: auto-renewable  # products in a family group must be of auto-renewable type and be the same product but with different durations
          duration: 6 Months    # specific values defined in the app metadata specification outline
          free_trial_duration: 1 Month
          bonus_duration: 1 Month
          cleared_for_sale: true
          wholesale_price_tier: 5
        - product_id: one_year_subscription
          type: auto-renewable  # products in a family group must be of auto-renewable type and be the same product but with different durations
          duration: 1 Year    # specific values defined in the app metadata specification outline
          bonus_duration: 2 Months
          cleared_for_sale: true
          wholesale_price_tier: 9
      locales:
        - name: en
          title: Sample Product Group
          description: All your products in this sample group
          publication_name: Sample Product Group
  other_purchases:
    - product_id: one_hundred_dollars
      reference_name: 100 dollars
      type: consumable
      review_screenshot_image: test.jpg
      cleared_for_sale: true
      wholesale_price_tier: 1 # pricing tier matrix is available in Exhibit C of the iOS Paid Applications contract in the Contracts, Tax, and Banking section of iTunes Connect 
      locales:
        - name: en
          title: $100
          description: An extra $100 for you
    - product_id: new_level
      reference_name: Unlocks a new level
      type: non-consumable
      review_screenshot_image: test.jpg
      cleared_for_sale: true
      intervals:
        - start_date: 2013-01-31
          end_date: 2013-02-28
          wholesale_price_tier: 3
      locales:
        - name: en
          title: Unlocks a new level
          description: Try your luck at this new level
```

This configuration will generate the following metadata.xml:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<package xmlns="http://apple.com/itunes/importer" version="software5.0">
  <provider>SampleCompany</provider>
  <team_id>ABCDE12345</team_id>
  <software>
    <vendor_id>sample sku</vendor_id>
    <software_metadata>
      <versions>
        <version string="1.1.3.1">
          <locales>
            <locale name="en-US">
              <title>sampleApp</title>
              <description>Description of sampleApp.</description>
              <keywords>
                <keyword>Sample</keyword>
                <keyword>App</keyword>
              </keywords>
              <version_whats_new>Version Whats New.</version_whats_new>
              <software_url>http://example.com</software_url>
              <privacy_url>http://example.com</privacy_url>
              <support_url>http://example.com</support_url>
              <software_screenshots>
                <software_screenshot display_target="iOS-3.5-in" position="1">
                  <file_name>test.jpg</file_name>
                  <size>20092</size>
                  <checksum type="md5">ff5bd97a5f40bb75a84884589ecbfc42</checksum>
                </software_screenshot>
              </software_screenshots>
            </locale>
          </locales>
        </version>
      </versions>
      <game_center>
        <achievements>
          <achievement position="1">
            <achievement_id>com.samplecompany.applicationname.first_achievement</achievement_id>
            <reference_name>First Achievement</reference_name>
            <points>10</points>
            <hidden>false</hidden>
            <reusable>false</reusable>
            <locales>
              <locale name="en">
                <title>First Achievement</title>
                <before_earned_description>Complete a task</before_earned_description>
                <after_earned_description>Completed a task</after_earned_description>
                <achievement_after_earned_image>
                  <file_name>test.jpg</file_name>
                  <size>20092</size>
                  <checksum type="md5">ff5bd97a5f40bb75a84884589ecbfc42</checksum>
                </achievement_after_earned_image>
              </locale>
            </locales>
          </achievement>
        </achievements>
        <leaderboards>
          <leaderboard default="true" position="1">
            <leaderboard_id>com.samplecompany.applicationname.top_scores</leaderboard_id>
            <reference_name>Top Scores</reference_name>
            <sort_ascending>false</sort_ascending>
            <locales>
              <locale name="en">
                <title>Top Scores</title>
                <formatter_suffix> Points</formatter_suffix>
                <formatter_suffix_singular> Point</formatter_suffix_singular>
                <formatter_type>INTEGER_COMMA_SEPARATOR</formatter_type>
                <leaderboard_image>
                  <file_name>test.jpg</file_name>
                  <size>20092</size>
                  <checksum type="md5">ff5bd97a5f40bb75a84884589ecbfc42</checksum>
                </leaderboard_image>
              </locale>
            </locales>
          </leaderboard>
        </leaderboards>
      </game_center>
      <in_app_purchases>
        <family name="Sample Product Group">
          <locales>
            <locale name="en">
              <title>Sample Product Group</title>
              <description>All your products in this sample group</description>
              <publication_name>Sample Product Group</publication_name>
            </locale>
          </locales>
          <review_screenshot>
            <file_name>test.jpg</file_name>
            <size>20092</size>
            <checksum type="md5">ff5bd97a5f40bb75a84884589ecbfc42</checksum>
          </review_screenshot>
          <review_notes/>
          <in_app_purchase>
            <product_id>com.samplecompany.applicationname.six_month_subscription</product_id>
            <duration>6 Months</duration>
            <free_trial_duration>1 Month</free_trial_duration>
            <bonus_duration>1 Month</bonus_duration>
            <type>auto-renewable</type>
            <products>
              <product>
                <cleared_for_sale>true</cleared_for_sale>
                <wholesale_price_tier>5</wholesale_price_tier>
              </product>
            </products>
          </in_app_purchase>
          <in_app_purchase>
            <product_id>com.samplecompany.applicationname.one_year_subscription</product_id>
            <duration>1 Year</duration>
            <bonus_duration>2 Months</bonus_duration>
            <type>auto-renewable</type>
            <products>
              <product>
                <cleared_for_sale>true</cleared_for_sale>
                <wholesale_price_tier>9</wholesale_price_tier>
              </product>
            </products>
          </in_app_purchase>
        </family>
        <in_app_purchase>
          <product_id>com.samplecompany.applicationname.one_hundred_dollars</product_id>
          <reference_name>100 dollars</reference_name>
          <type>consumable</type>
          <products>
            <product>
              <cleared_for_sale>true</cleared_for_sale>
              <wholesale_price_tier>1</wholesale_price_tier>
            </product>
          </products>
          <locales>
            <locale name="en">
              <title>$100</title>
              <description>An extra $100 for you</description>
            </locale>
          </locales>
          <review_screenshot>
            <file_name>test.jpg</file_name>
            <size>20092</size>
            <checksum type="md5">ff5bd97a5f40bb75a84884589ecbfc42</checksum>
          </review_screenshot>
        </in_app_purchase>
        <in_app_purchase>
          <product_id>com.samplecompany.applicationname.new_level</product_id>
          <reference_name>Unlocks a new level</reference_name>
          <type>non-consumable</type>
          <products>
            <product>
              <cleared_for_sale>true</cleared_for_sale>
              <intervals>
                <interval>
                  <start_date>2013-01-31</start_date>
                  <end_date>2013-02-28</end_date>
                  <wholesale_price_tier>3</wholesale_price_tier>
                </interval>
              </intervals>
            </product>
          </products>
          <locales>
            <locale name="en">
              <title>Unlocks a new level</title>
              <description>Try your luck at this new level</description>
            </locale>
          </locales>
          <review_screenshot>
            <file_name>test.jpg</file_name>
            <size>20092</size>
            <checksum type="md5">ff5bd97a5f40bb75a84884589ecbfc42</checksum>
          </review_screenshot>
        </in_app_purchase>
      </in_app_purchases>
    </software_metadata>
  </software>
</package>

```

## Todo
* TESTS. High on my list
* RDocs. Definitely need to document this.
* Metadata validation. There are lots of rules depending on what values you provide. You should know when you generate the package if there are any issues instead of having Apple tell you when you upload
* Anything else! Pull requests are welcome! This is my first Ruby project so I'm sure there is are a lot of improvements that can be made
* <s>Finish in-app purchase XML generation (lots of different options here!)</s>

## Contact

Colin Humber

- http://github.com/colinhumber
- http://twitter.com/colinhumber

## License

itmsp is available under the MIT license. See the LICENSE file for more info.
