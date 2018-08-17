### What is TBXML

TBXML is a light-weight XML document parser written in Objective-C designed for use on Apple iPad, iPhone & iPod Touch devices (also Mac OSX compatible). TBXML aims to provide the fastest possible XML parsing whilst utilising the fewest resources. This requirement for absolute efficiency is achieved at the expense of XML validation and modification. It is not possible to modify and generate valid XML from a TBXML object and no validation is performed whatsoever whilst importing and parsing an XML document.

### Performance

TBXML is incredibly fast! Check out this post for a good comparison of XML parsers. [How To Chose The Best XML Parser for Your iPhone Project](http://www.raywenderlich.com/553/how-to-chose-the-best-xml-parser-for-your-iphone-project "How To Chose The Best XML Parser for Your iPhone Project")

### Design Goals

* XML files conforming to the W3C XML spec 1.0 should be passable
* XML parsing should incur the fewest possible resources
* XML parsing should be achieved in the shortest possible time
* It shall be easy to write programs that utilise TBXML

### What Now?

Have a play with the [TBXML-Books](https://github.com/71squared/TBXML-Books) sample project

View the "TBXML" wiki page to get find out how TBXML works. It contains many examples showing you how to use TBXML to parse your XML files. There are 2 complementary additions to extend the functionality of TBXML. These add the ability to automatically decompress files and perform asynchronous HTTP requests.

[TBXML](https://github.com/71squared/TBXML/wiki/TBXML)   
[TBXML+Compression](https://github.com/71squared/TBXML/wiki/TBXML+Compression)   
[TBXML+HTTP](https://github.com/71squared/TBXML/wiki/TBXML+HTTP)   


<br/>
Love the project? Wanna buy me a coffee? [![donation](http://www.paypal.com/en_US/i/btn/btn_donate_SM.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=9629667)


<br/>
<br/>

### MIT License
  Copyright 2012 71Squared All rights reserved.
  
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:
  
  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.
  
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.