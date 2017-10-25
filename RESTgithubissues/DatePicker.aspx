<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DatePicker.aspx.cs" Inherits="RESTgithubissues.DatePicker" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Date Picker</title>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link href="~/Styles/Site.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="jscript/alpine.js"></script>
</head>
<body>
    <form id="form2" runat="server">
    <h3><asp:Label runat="server" ID="lbmain"></asp:Label></h3>
    <div>
    <span class="floatRight">Month <asp:DropDownList runat="server" ID="ddlmonths" OnSelectedIndexChanged="ddlmonths_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
 Year <asp:DropDownList runat="server" ID="ddlyears" OnSelectedIndexChanged="ddlyears_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>&nbsp;&nbsp;
 <asp:LinkButton runat="server" ID="lbtoday" OnClick="lbtoday_Click" Text="Go&nbsp;To&nbsp;Today"></asp:LinkButton>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>

<asp:Calendar ID="Calendar1" runat="server" ondayrender="Calendar1_DayRender" 
        Width="98%"  DayStyle-HorizontalAlign="Left" TitleStyle-CssClass="caltitle"
        DayStyle-VerticalAlign="Top" onvisiblemonthchanged="Calendar1_VisibleMonthChanged" OtherMonthDayStyle-CssClass="othermonth" OnSelectionChanged="Calendar1_SelectionChanged"  >
        </asp:Calendar>
    

    </div>
        <div style="display:none;">
    <asp:TextBox runat="server" ID="txtdate" ></asp:TextBox>
    <asp:HiddenField runat="server" ID="ctdob" />
    <asp:HiddenField runat="server" ID="ctdate" />
    <input type="text" id="pv" name="pv" value="<%=Request["pv"] %>" />
            </div>
    <div>
    <br />
    <asp:Button runat="server" ID="btncancel" Text="Close" OnClientClick="javascript:closeme();return false;" />
    </div>

    </form>
    <script type="text/javascript">
        var thedate = document.getElementById("txtdate").value;
        var i2 = document.getElementById("pv").value;

        if (thedate.length > 0) {
            opener.datereceived(i2, thedate);
        }
        function closeme() { window.location.href = "CloseMe.aspx"; }
        function accomReceive(pd, pa, pf, po) {
            opener.accomReceive(i2, pd, pa, pf,po); //i2=element name
        }
        function thingwait(p) {
            window.opener.thingwait(p);
        }
    </script>
    <div>
    </div>

</body>
</html>
