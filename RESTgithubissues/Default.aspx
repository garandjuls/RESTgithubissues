<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RESTgithubissues.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .captioning caption {
            background-color: #EAEAEA;
            text-align: left;
            padding: 4px 4px;
            font-weight: bold;
            border-style: solid;
            border-width: 1px;
            border-color: #000000;
        }
        #spanhidden { display:none; position:absolute; background-color:beige;}
        #spanparent:hover #spanhidden { display:block;}

        .tablealt tr:nth-child(2n) {
            background-color: #DADADA;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <div>FRONT END
            <pre>
Your task is to integrate with the Github REST API to search for issues in the Angular Github repo for 
the previous 7 days.
Use the Github Issues API. As before, the frameworks are up to you, 
however working with AngularJS or ReactJS will be seen as a plus. 
With the results from the API, display, in HTML, the returned values with their 
title, body, user login, and assignee login.
The HTML display can be as plain or intricate as you like, in any manner you choose.
                </pre>
</div>
        <div>
            <table style="width:60%;">
                <tr>
                    <td style="width:20%;">Root URL Part</td>
                    <td><input type="text" id="txtpath" value="https://api.github.com/repos/vmg/redcarpet/issues" style="width:80%;" /></td>
                </tr>
                <tr>
                    <td>Items Added/Updated Since This Date</td>
                    <td><input type="text" id="txtdate" />&nbsp;<a href='#' onclick="javascript:return clickcalpop('txtdate');"><img src="http://garandjuls.com/images/cal1.png" width="30px" alt="date picker" class="bottoms" /></a></td>
                </tr>
                <tr>
                    <td>Items Per Page</td>
                    <td><input type="text" id="txtperpage" value="30" /></td>
                </tr>
                <tr>
                    <td>Page Number</td>
                    <td><input type="text" id="txtpage" value="1" /></td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align:center;">
                        <input type="button" value="Submit" onclick="noteread()" />
                    </td>
                </tr>
            </table>
        </div>


        <div>&nbsp;</div>
        Click on an Issue ID to view complete details   

        <table id="table1" border="1" title="All Notes" class="tablealt captioning" cellspacing="4" cellpadding="4" >
            <caption>
			Awaiting user input
		</caption>
            <thead >
                <tr  >
                    <td>ID</td>
                    <td>Title</td>
                    <td>Body</td>
                    <td>User Login</td>
                    <td>Assignees</td>
                </tr>
            </thead>
        </table>

    </div>
        <div style="height:80px;">&nbsp;</div>

    <script type="text/javascript">
        // do async
        var xhttp;
        // url to post to
        function syncJsonPost(purl, pmethod) {
            if (window.XMLHttpRequest) {
                xhttp = new XMLHttpRequest();
            } else {
                // code for IE6, IE5
                xhttp = new ActiveXObject("Microsoft.XMLHTTP");
            }
            xhttp.onreadystatechange = function () {
                if (xhttp.readyState == 4 && xhttp.status == 200) {
                    showit(xhttp.responseText);
                }
            };
            xhttp.open(pmethod, purl, false);
            xhttp.send(null);
        }

        // populates the fields
        function showit(ptext) {
            var myObj = JSON.parse(ptext);
            var table = document.getElementById("table1");
            if (table.rows.length > 1) { // clear it
                for(var cr=table.rows.length; cr > 1; cr--)
                {
                    table.deleteRow(cr-1);
                }
            }
            var keys = "number,title,body";
            var loopkey = keys.split(","); // for redundant simple fields

            for (var iob = 0; iob < myObj.length; iob++) {
                var row = table.insertRow(table.rows.length);                

                var thisobj = myObj[iob];

                // plow through non-special fields
                for (var loop = 0; loop < loopkey.length; loop++) {
                    var ctcell1 = row.insertCell(row.cells.length);
                    ctcell1.style["vertical-align"] = "top";

                    if (loop == 0) { // only do for cell 0. create a link to detail page
                        var link = document.createElement("a");
                        link.setAttribute("href", "javascript:rowclick(" + thisobj[loopkey[loop]] + ")");
                        var linkText = document.createTextNode(thisobj[loopkey[loop]]);
                        link.appendChild(linkText);

                        ctcell1.appendChild(link);
                    }
                    else {

                        // check for arbitrary field lenght and truncate. in that case add a link ellipsis (...) 
                        var maxlen = 100;
                        var thisval = thisobj[loopkey[loop]];
                        if (thisval.length > maxlen) {
                           // add (...) and add hidden div with full text
                            var link = document.createElement("a");
                            link.setAttribute("href", "javascript:showmore('" + thisval + "')");
                            var div = document.createElement("div");
                            div.innerHTML = thisval;
                                  div.id = "spanhidden";

                            var linkText = document.createTextNode("(more)");
//                            link.id = "spanhidden";

                            thisval = thisval.substring(0, maxlen) + " ";
                            ctcell1.innerHTML = thisval;

                            link.appendChild(linkText);

                            var span = document.createElement("span");
                            span.id = "spanparent";
                            span.appendChild(link);
                            span.appendChild(div);

                            ctcell1.appendChild(span);

                        }
                        else
                            ctcell1.innerHTML = thisval;
                    }
                }

                // nested value field
                var ctcell1 = row.insertCell(row.cells.length);
                ctcell1.innerHTML = thisobj.user.login;
                ctcell1.style["vertical-align"] = "top";

                // assignees nested possible array of assignees fields
                // loop through assignees
                var sassign = ""; // used for final output
                var assignessObj = thisobj.assignees;
                if (assignessObj) {
                    for (iasgn = 0; iasgn < assignessObj.length; iasgn++) {
                        if (sassign.length > 0)
                            sassign += ", ";
                        sassign += assignessObj[iasgn].login;
                    }
                }
                ctcell1 = row.insertCell(row.cells.length);
                ctcell1.innerHTML = sassign;
                ctcell1.style["vertical-align"] = "top";
            }
            table.caption.innerHTML = (table.rows.length -1).toString() + " Results";
        }

        // perform the get request
        function noteread() {
            var qry = "";
            var root = document.getElementById("txtpath").value;
            var since = document.getElementById("txtdate").value;
            if (since.length > 0)
            { qry += "?since=" + since;}
            var pagesize = document.getElementById("txtperpage").value;
            if (pagesize.length > 0)
                if (qry.length == 0)
                    qry = "?";
                else
                    qry += "&";
            qry += "per_page=" + pagesize;
            var pageno = document.getElementById("txtpage").value;
            if (pageno.length > 0)
                if (qry.length == 0)
                    qry = "?";
                else
                    qry += "&";
            qry += "page=" + pageno;
            syncJsonPost(root + qry, "GET"); // QueryString
        }

        // launch detail page
        function rowclick(pid)
        {
            var root = document.getElementById("txtpath").value;
            var winhandle = window.open(root + "/" + pid, "detailPopup");
        }

        var pophandle;
        function clickcalpop(eid) { //element id to populate with result of calendar
            if (pophandle) pophandle.close();
            var ctdate = "";
            if (document.getElementById(eid))
                ctdate = document.getElementById(eid).value;
            pophandle = window.open("DatePicker.aspx?pv=" + eid + "&cdt=" + ctdate, "datepick", "menubar=no,toolbar=no,width=400,height=300", true);
            return false;
        }
        // response from date picker
        function datereceived(aa, thedate) {
            pophandle.close();
            var dateArray = thedate.split("/");
            document.getElementById(aa).value = dateArray[2] + "-" + dateArray[0] + "-" + dateArray[1];
        }

        function formatDate(pdate) {
            var outstring = pdate.getFullYear().toString() + "-" + (pdate.getMonth() + 1).toString() + "-" + pdate.getDate().toString();
            return outstring;
        }
        // on 1st load
        var oneWeekAgo = new Date();
        oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);
        document.getElementById("txtdate").value = formatDate(oneWeekAgo);
        </script>
        </form>
    </body>
    </html>