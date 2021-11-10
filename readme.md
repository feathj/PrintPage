# PrintPage
## A simple swiftui app to help print coloring pages.


Generate API Keys
-----------------
1) Navigate to google custom search api page https://developers.google.com/custom-search/v1/introduction
2) Click on "Get a Key"
3) Use existing project or create a new one, click next
4) Take note of your API key for use below
5) Navigate to search API page https://programmablesearchengine.google.com/cse/create/new
6) Switch to "New control panel"
7) Name your new search engine, eg "PrintPage"
8) Click "Search entire web" under "What to search?"
9) Toggle on "Image search" and "SafeSearch" under "Search Settings"
10) Click "Create"
11) Click "Back" and click your engine name under "All Search engines"
12) Take note of your "Search Engine ID" under the "Basics" tab

Note that the free tier of this API will allow up to 100 search requests per day

Installation
------------
1) Build from source (current supported xcode version is 13.1)
2) Run application
3) Navigate to "preferences" menu
4) Fill api information with API Key and Search Engine ID from above ^
5) Close preferences menu and search for coloring pages
6) Click "Load More" button at bottom to load more search results. Number of pages is capped to 5 to prevent exhausting max number of API searches in 24 hr period (100). Note that image and search results are cached to prevent API thrashing. To clear cache, click "Clear Cache" on preferences menu.
