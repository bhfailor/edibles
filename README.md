# edibles #

Use this service, in conjunction with a Google Sheet, to track weekly nutritional intake.  This service returns a record of nutritional information pulled from the [USDA database](https://ndb.nal.usda.gov/ndb/search/list) that can be pasted into the sheet named "data" of a Google spreadsheet [workbook](https://docs.google.com/spreadsheets/d/1crP1tpb7hCJXW_k53fV2YljaBTTYbEE-zHU5lQ39umM/edit?usp=sharing).

The goal is to quickly (i.e. inexpensively) reproduce the capabilities of http://nutritiondata.self.com/  with (1) much less latency, (2) much more transparency regarding how the nutrient values are calculated, and (3) more flexibility in the assigment of custom nutritional information.

The spreadsheet (1) allows USDA database foods to be combined into composite foods that can, in turn, be used to construct of other composite foods, (2) displays the RDA status for tracked nutrients, and (3) calculates the composite food cost.

### How do I get set up? ###

* Summary of set up

`bundle install` should fetch the needed gems and
`rails server` should start the server.  No database is used.

* Configuration

An API key is needed to access the [USDA database](https://ndb.nal.usda.gov/ndb/search/list).  The should be included in a `.env` file located in the root directory of the Rails application.  An example of such a line:
`DATA_DOT_GOV_API_KEY=gmTDakoSpaC2hzwH4Psjv5kpyxl2Qge3pTxFNzQ3`

* Dependencies

The only dependencies should be the gems called out in the `Gemfile`.

* Database configuration

There is no database involved.

* How to run tests

`rspec spec` executes all the tests.

* Deployment instructions

`rails server` should start the server using the default, e.g. `thin`.  See `spec/features/display_food_spec.rb` for an example of standard operation.  I follow 3 steps:

1. Find the USDA number for a food of interest from the [USDA database](https://ndb.nal.usda.gov/ndb/search/list)
2. Enter it on the app's root page and submit the form
3. At the bottom of the response page is a text window.  Copy all the text in the window to the clipboard and paste it into a row on the "data" sheet of the Google spreadsheet.
4. Fill in user-supplied values in the row, including cost ($), vegetable mass (g), and fruit mass (g) per unit measure.
5. Now that row can be referenced on other sheets of the spreadsheet.

### Who do I talk to? ###

* Bruce Failor
* bruce.failor@gmail.com