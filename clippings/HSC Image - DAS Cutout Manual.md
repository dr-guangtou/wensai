---
title: HSC Image - DAS Cutout Manual
source: "https://hscdata.mtk.nao.ac.jp/das_quarry/dr4/manual.html#list-to-upload"
author:
  - "[[NAOJ]]"
tags:
  - clippings
  - project/hsc
published:
created: 2026-02-28
description:
---
## DAS Cutout manual

In [DAS Cutout](https://hscdata.mtk.nao.ac.jp/das_quarry/dr4/index.html) you can get a FITS image cut out from large coadd images stored in DAS. Specify a [rectangle](https://hscdata.mtk.nao.ac.jp/das_quarry/dr4/#rectangles) by (ra, dec), and you will get a FITS image through HTTP.

There may be several reruns or tracts covering the [rectangle](https://hscdata.mtk.nao.ac.jp/das_quarry/dr4/#rectangles) you want. In that case, unless you specify a rerun or tract, one of them is automatically chosen: the tract whose center the rectangle is the nearest to.

## Available file types

### coadd

This is the default option. A coadd FITS file is retrieved. It is cut out from coadd patches stored in DAS with the names of {rerun}/{time}/deepCoadd\_calexp/{tract}/{patch}/{band}/deepCoadd\_calexp\_\*.fits. This is the image on which objects in the database were detected and measured.

### coadd/bg

With this option, too, a coadd image is returned. But unlike the option "coadd", it is an intermediate state just after coaddition and before aggressive background subtraction. It is cut out from coadd patches stored in DAS with the names of {rerun}/{time}/deepCoadd/{tract}/{patch}/{band}/deepCoadd\_\*.fits. This is **not** the image on which objects in the database were detected and measured, but it is useful around extended objects affected by the aggressive background subtraction.

### warp

Instead of a coadd, the warped-only CCD images that are co-added in the coadd can be retrieved at your option. If you select this option, you will get an uncompressed *tar file* instead of a FITS file. In the tar file, each warped-only CCD images will be stored named warp-{visit}.fits. The original files for these ones are stored in DAS with the names of {rerun}/{time}/deepCoadd\_directWarp/{tract}/{patch}/{dateobs}/{band}/{filter}/{visit}/deepCoadd\_directWarp\_\*.fits.

## File format

A FITS file cut out consists of 4 hdu's (header-data units, or layers): The primary hdu (0th hdu) does not contain any data. The 1st hdu is the image layer, the 2nd hdu is the mask layer, and the 3rd the variance layer.

These hdu positions are immobile. If you say you want the image and the variance layer (and not the mask layer), then, in the cutout file, the 0th hdu is empty, the 1st hdu contains the image, the 2nd hdu is empty, and the 3rd hdu holds the variance. Thus empty hdu's are not removed.

## Rectangles

A cutout rectangle has two adjacent sides that are respectively parallel to x- and y- axis of coadd images. No other option is provided.

You should beware that the y-axis of a cutout image is almost directed to the north, but **not exactly** since the center of WCS projection is not the center of the cutout image but the center of the tract it resides.

Similarly, the pixel scale is **not uniform** because it depends on the distance between the cutout rectangle and the center of the tract. Shapes of objects in the cutout image are **distorted** because the coordinates are not orthogonal apart from the center of the tract.

Anyway, WCS headers are correctly included in the obtained file, so that you can use them if you care about the above things.

There are two options for telling a rectangle you want. The better-defined way is to give two diagonal corners of the rectangle. The other two corners are computed from them with the WCS. If, otherwise, you specify the center and size of a rectangle, the rectangle is defined in a plane tangent to the celestial sphere at the center of the rectangle. Two of the vertices of the rectangle are chosen in the tangent plane, and projected back to the celestial sphere to be the “two diagonal corners” passed into the region-selecting routine.

## Value formats for input fields

### ra

RA fields can be either:

- Degrees: 33, 33.0, &c.
- Hours: 2:12:00.0, 2h12m00.0s, &c.
- [Suffixed angle](https://hscdata.mtk.nao.ac.jp/das_quarry/dr4/#suffixes): 33deg, 0.576rad, &c.

### dec

DEC fields can be either:

- Degrees: 3.5, &c.
- Sexagesimal deg.: 3:30:00.0, 3d30m00.0s, &c.
- [Suffixed angle](https://hscdata.mtk.nao.ac.jp/das_quarry/dr4/#suffixes): 3.5deg, 0.0611rad, &c.

### semi-width/height (sw/sh)

Semi-width/height fields can be either:

- Degrees: 0.02, &c.
- [Suffixed angle](https://hscdata.mtk.nao.ac.jp/das_quarry/dr4/#suffixes): 1.2arcmin, 72arcsec, &c.

## Angle suffixes

The following suffixes can be used in expressing angles:

- deg, degrees: Degrees.
- amin, arcmin, arcminutes: Arcminutes.
- asec, arcsec, arcseconds: Arcseconds.
- rad, radians: Radians.

## Coordinate list to upload

### List format

A list of coordinates can be uploaded instead of feeding them one by one. The resultant images will be returned as an uncompressed tar file. Line numbers in the list will be prefixed to the names of the files in the tar-ball. Note the line number usually **begins with 2** since the first line is a column descriptor (see below).

The server first examines the uploaded list to ensure its format is adequate. If the server finds a flaw in so doing, it will report it to the user.

If the server is sure that the uploaded list is adequate, it will start to deliver images according to the list. Any errors that will occur in this stage (e.g. no image found at specified coordinates) will silently be ignored, and the files that caused the error will be excluded from the resultant tar-ball. You will be able to notice the lacks by not finding files whose names start with certain line numbers.

An example of a coordinate list is:

```
#? rerun      filter    ra       dec       sw     sh  # column descriptor
   s23b_wide    g    -1:36:00  00:00:00  2asec  2asec #
   s23b_wide    r    -1:36:00  00:00:00  2asec  2asec #
   s23b_wide    i    -1:36:00  00:00:00  2asec  2asec # list of coordinates
   s23b_wide    z    -1:36:00  00:00:00  2asec  2asec #
   s23b_wide    y    -1:36:00  00:00:00  2asec  2asec #
```

A *column descriptor* that begins with `#?` must be present at the start of the list. It describes the columns of the table that is listed below it. Columns are chosen from the [available columns](https://hscdata.mtk.nao.ac.jp/das_quarry/dr4/#list-columns). The order of columns is arbitrary, but the table that follows must assort to the order described in the column descriptor.

By the above example list, you will obtain coadds' image layer only. Suppose you need mask and variance layers, and also warped files. Then you have to add more columns as below:

```
#? rerun        ra       dec       sw    sh   filter  image  mask variance type
  s23b_wide  -1:36:00  00:00:00  2asec  2asec    g    true   true   true   coadd
  s23b_wide  -1:36:00  00:00:00  2asec  2asec    g    true   true   true   warp
  s23b_wide  -1:36:00  00:00:00  2asec  2asec    r    true   true   true   coadd
  s23b_wide  -1:36:00  00:00:00  2asec  2asec    r    true   true   true   warp
  s23b_wide  -1:36:00  00:00:00  2asec  2asec    i    true   true   true   coadd
  s23b_wide  -1:36:00  00:00:00  2asec  2asec    i    true   true   true   warp
  s23b_wide  -1:36:00  00:00:00  2asec  2asec    z    true   true   true   coadd
  s23b_wide  -1:36:00  00:00:00  2asec  2asec    z    true   true   true   warp
  s23b_wide  -1:36:00  00:00:00  2asec  2asec    y    true   true   true   coadd
  s23b_wide  -1:36:00  00:00:00  2asec  2asec    y    true   true   true   warp
```

Columns with only one constant value (like `rerun`, `sw`, `sh`, `image`, `mask`, `variance` in the example above) can be omitted from the list, and instead be specified by the "Default values" input boxes of the web page.

Be careful of [limitations](https://hscdata.mtk.nao.ac.jp/das_quarry/dr4/#limitations).

### Available columns

One of the following sets of columns must appear in the column descriptor:

ra1, dec1, ra2, dec2

Specify a rectangle by two diagonal corners (ra1, dec1), (ra2, dec2). See also [value formats](https://hscdata.mtk.nao.ac.jp/das_quarry/dr4/#formats).

ra, dec, sw, sh

Specify a rectangle by its center (ra, dec), semi-width (sw) and semi-height (sh). See also [value formats](https://hscdata.mtk.nao.ac.jp/das_quarry/dr4/#formats).

The following columns can optionally appear in the column descriptor:

filter

Filter name. Default: i. Possible values are:
- g
- r
- i
- z
- y
- n387
- n816
- n921
- n1010
Some users can use the following values:
- MegaCam-u
- MegaCam-uS
- VIRCAM-H
- VIRCAM-J
- VIRCAM-Ks
- VIRCAM-NB118
- VIRCAM-Y
- WFCAM-H
- WFCAM-J
- WFCAM-K

rerun

Rerun name. Default: any. Possible values are:
- ~~any (One of the following reruns is automatically selected)~~. We recommend you not to use this keyword because it is not predictable which rerun will be auto-selected.
- s17a\_dud
- s17a\_wide
- s18a\_dud
- s18a\_wide
- s19a\_dud
- s19a\_wide
- s20a\_dud2
- s20a\_dud\_old
- s20a\_wide
- s21a\_dud2
- s21a\_dud\_old
- s21a\_wide
- s23b\_deep
- s23b\_wide
Some users can use the following values:
- s18a\_dud\_u2k
- s21a\_dud2\_u2k

tract

Tract number. Default: any.  
A value of this column is a decimal number or “ any ”.

image

Whether or not you need the image layer. Default: true.

mask

Whether or not you need the mask layer. Default: false.

variance

Whether or not you need the variance layer. Default: false.

type

File type (“ coadd ”, “ coadd/bg ”, or “ warp ”). Default: coadd.

nodata

If you set this to true, the rectangle will be cut out even if there are no-data areas in it. Default: false.

name

Output file name (without extension like ".fits")

## Limitations

### Image size

You cannot cut out more than around 3 × 3 patches. This limitation is imposed on the number of pixels. It is not forbidden to cut out a long and thin area.

If you want a larger image, go to [DAS Search Template](https://hscdata.mtk.nao.ac.jp/das_console) to get whole patches.

If you cannot find an image that is smaller than this limit, there are probably some pixels for which no source images are found. See [“Rectangle not found in observed area”](https://hscdata.mtk.nao.ac.jp/das_quarry/dr4/#rectangle-not-found).

### Number of images

In [list-uploading mode](https://hscdata.mtk.nao.ac.jp/das_quarry/dr4/#list-to-upload), the number of images you can get at a time is limited to 100000. If you should request more than the limit, the server would refuse the request. (In other words, you would get no image at all.)

## Frequently asked questions

### Flux unit

Pixels in the image layer are in such a unit that makes this equation hold for stars (as opposed to galaxies).

(AB magnitude) = -2.5 log(flux / FLUXMAG0)

FLUXMAG0 is inscribed in the FITS header.

flux is the sum of the values of the pixels within 12-pixel-radius (24-pixel-diameter) aperture around a star. Notice flux here is not aperture-corrected. Though flux is not a total flux,\-2.5 log(flux / FLUXMAG0) gives the correct magnitude. The images are so calibrated.

Accordingly, if you want to accurately measure a total flux (of a star or a galaxy as well), you will have to multiply the raw total flux by a certain value less than 1. In our catalog database, the multiplier is called "aperture correction" apCorr < 1:

apCorr = (12-pixel-radius aperture flux of PSF) / (total flux of PSF)

If you want to compare total fluxes of your own measuring with fluxes in our catalog database, you should remember that the fluxes in our database are not raw values but corrected values: they are (apCorr) × (raw values).

## Trouble shooting

If the server cannot deliver a file to you, it will answer with "404 Not Found". You must be seeing an error message together with a traceback. Please send us the traceback if you cannot solve the problem for yourself.

We comment on some typical error messages.

### “Rectangle not found in observed area”

The rectangle is “found” if and only if:

1. There are some tracts which cover the whole rectangle (It is not valid for a union of two or more tracts to cover the rectangle); and
2. For at least one of the tracts, all patches are present that are required to paint the rectangle. This condition may not hold at the very edge of a surveyed area, for example.

You can ignore the 2nd condition by checking "Permit nodata area".

The larger the rectangle is, the more likely it is that (1) the rectangle will extend outside the tract (projection zone), or (2) the rectangle will include a no-data area where there is not a source image due to a failure of the data processing. In the case of (2), you can check "Permit nodata area" to cut out the rectangle forcibly, but in the case of (1) you cannot get the cutout corresponding to the rectangle.

A rectangle being found for a certain filter does not mean the same rectangle being found for another filter.

### “resultant image size exceeds limit”

See [limitations](https://hscdata.mtk.nao.ac.jp/das_quarry/dr4/#limitations).

## Download speed is slow

To accelerate download speed in ["Upload list"](https://hscdata.mtk.nao.ac.jp/das_quarry/dr4/index.html#bulk) mode, arrange the contents of the list in such an order that source images (from which to cut out requested images) do not switch frequently. We recommend arranging the contents of the list in the dictionary order of (filter, tract, ra, dec), or (filter, ra, dec) if you do not know "tract". If the uploaded list is arranged in this order, the cutout server can use caches of decoded source images.

A common mistake is to group records of different bands of the same (ra, dec) and to list the records group by group. A good practice is to first list all ('g', ra, dec), then list all ('r', ra, dec), then list all ('i', ra, dec),...

## Want to use wget or curl?

### Get a single file

A link “(link)” will appear to the right of the “Cutout” button when the button is enabled. You can copy & paste the link if you want to use a command line tool to download it.

You can successively get other files by changing the suffix of the url. We recommend that you create a url list like:

```
https://hscdata.mtk.nao.ac.jp/das_quarry/dr4/cgi-bin/cutout?ra=-24&dec=0&sw=2asec&sh=2asec&type=coadd&image=on&filter=g&tract=&rerun=s23b_wide
https://hscdata.mtk.nao.ac.jp/das_quarry/dr4/cgi-bin/cutout?ra=-24&dec=0&sw=2asec&sh=2asec&type=coadd&image=on&filter=r&tract=&rerun=s23b_wide
https://hscdata.mtk.nao.ac.jp/das_quarry/dr4/cgi-bin/cutout?ra=-24&dec=0&sw=2asec&sh=2asec&type=coadd&image=on&filter=i&tract=&rerun=s23b_wide
https://hscdata.mtk.nao.ac.jp/das_quarry/dr4/cgi-bin/cutout?ra=-24&dec=0&sw=2asec&sh=2asec&type=coadd&image=on&filter=z&tract=&rerun=s23b_wide
https://hscdata.mtk.nao.ac.jp/das_quarry/dr4/cgi-bin/cutout?ra=-24&dec=0&sw=2asec&sh=2asec&type=coadd&image=on&filter=y&tract=&rerun=s23b_wide
```

And feed the list (urllist.txt) to wget:

```
wget -i urllist.txt --user=YOURNAME --ask-password
```

### Upload a coord list

To upload a coord list, you have to post it in 'multipart/form-data'. (If you don't understand it, think it a certain type of protocol.) Wget, as of version 1.14, does not support the protocol. You should instead use curl as:

```
curl 'https://hscdata.mtk.nao.ac.jp/das_quarry/dr4/cgi-bin/cutout' --form list=@coordlist.txt --user YOURNAME | tar xvf -
```

↑ coordlist.txt is a coordinate list as described in [Coordinate list to upload](https://hscdata.mtk.nao.ac.jp/das_quarry/dr4/#list-to-upload).

To specify values of columns not present in the uploaded list, append them to the URL:

```
curl 'https://hscdata.mtk.nao.ac.jp/das_quarry/dr4/cgi-bin/cutout?filter=g&sw=1arcmin&sh=1arcmin&image=true&variance=true&mask=true' --form list=@coordlist.txt --user YOURNAME | tar xvf -
```

## Command line tool

A command line tool is available: [downloadCutout](https://hsc-gitlab.mtk.nao.ac.jp/ssp-software/data-access-tools/-/tree/master/dr4/downloadCutout). This is a python script, and it requires python-3.7 or later. For usage, read `README.md` in the linked page.

## Contact address

If you have any questions or suggestions, please contact [hsc\_dr <hsc\_dr@hsc-software.mtk.nao.ac.jp>](https://hscdata.mtk.nao.ac.jp/das_quarry/dr4/).