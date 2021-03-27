# bookmark_manager

## To use
Set up both of the below databases following the command below
run rspec and get clean tests to ensure setup correctly
run rackup to start app
Connect in browser via localhost:*portname*

#### To set up the database for actual use
Connect to psql
Create the database using the psql command CREATE DATABASE **bookmark_manager**;
Connect to the database using the pqsl command \c bookmark_manager;
Run the query we have saved in the file 01_create_bookmarks_table.sql


#### Set up database for testing
Connect to psql
Create the database using the psql command CREATE DATABASE **bookmark_manager_test**;
Connect to the database using the pqsl command \c bookmark_manager_test;

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
