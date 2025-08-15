# Shelf AI Analysis in Snowflake
### Status: Work in Progress
Use Cortex AI and Meta's SegmentAnything model to analyze a shelf image for Category Management or Auditing. The goal of this demo is to show how images of store shelves can be processed for a number of purposes.

### Context & Business Problem
For many organizations in Retail - Brands, Retailers, and Distributors - having data about in-store conditions such as the condition of the shelf, the placement of products, promotions (end-caps and pallets), and out of stocks. 

### Approaches
There are several approaches that will be tried in this demo.
1. Leveraging native Snowflake Cortex multi-modal features to query the shelf
2. Using image segmentation techniques to process the image and break it up into components (e.g. products, shelves, price tags, etc)

### Outputs
Original shelf image
![Original shelf image of a packaged pasta brand called Wicked](/assets/shelf_original.png)

Segmented image using Meta's SegmentAnything v1.0
![A image segmented and annotated with different objects](/assets/shelf_segmented.png)

Masked and Cropped images for further AI analysis
![A masked image of one product and a zoomed in image of that product on shelf](/assets/shelf_cropped.png)
