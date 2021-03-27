# bookmark_manager

## To use
1. Set up both of the below databases following the command below
2. run rspec and get clean tests to ensure setup correctly
3. run `rackup -p 5001` to start app
4. Connect in browser via localhost:5001

#### To set up the database for actual use
1. Connect to psql
2. Create the database using the psql command 'CREATE DATABASE  bookmark_manager;'
3. Connect to the database using the pqsl command '\c bookmark_manager;'
4. Run the querys we have saved in the file `01_create_bookmarks_table.sql`


#### Set up database for testing
1. Connect to psql
2. Create the database using the psql command 'CREATE DATABASE bookmark_manager_test;'
3. Connect to the database using the pqsl command '\c bookmark_manager_test;'
4. Tables will create and reset automatically when you run rspec

## User Stories

As a user
So I can choose a website
I would like to see a list of bookmarks

| class     | instances | methods  |
|-----------|-----------|----------|
| user      | @username |          |
| bookmarks | @website  | list     |
|           |           |          |

As a user
So I can improve my list of bookmarks
I would like to be able to add new bookmarks

As a user
So I can remove my bookmark from Bookmark Manager
I want to delete a bookmark

As a user
So I can keep my bookmarks up to date
I want to be able to update bookmarks


URL *********** update delete
>update
> Title field Box
> Url Field box
> pre-filled with the databse entry
> an update button to perform the update.
> redirect you back to bookmarks


As a User
to provide notes on my bookmarks
I want to be able to add comments to my bookmark

bookmark one-to-many comments

final comment test not working???? - seems to be an issue with the display mechanism - seems to be displaying a single hash, not an array of hashes

#### Challenge 17 - Tags
As a user
I want to be able to tag bookmarks and I want to see all the tags on a bookmark

> Create Tables - DONE
> FEATURE TEST - Add and display Tags - DONE
> button - add tag
> implement tag button
> Add tag page
> bookmarks - display with tags

> Check if tag exists?
> If exists then retrieve comment id
> Otherwise create entry
> add tag into bookmark table.

DONE ##

As a user
I want to be able to click on a tag and see all bookmarks associated with that tag

> click on tag
> bookmarks/:tag - displays all bookmarks with that tag

TO IMPLEMENT ## - new feature 

Many to Many relationship

tags table - tagID, SERIAL PRIMARY KEY, content, VARCHAR(60)

Join table - bookmark_tags, bookmark_tagID, SERIAL PRIMARY KEY, bookmarkID REFERENCES bookmarks
tagID REFERENCES tags
