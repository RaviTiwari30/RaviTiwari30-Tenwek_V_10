<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="IncomeTaxReport.aspx.cs" Inherits="Design_Payroll_IncomeTaxReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    
    <script type="text/javascript">
        var cal1;
        function pageLoad() {
            cal1 = $find("calendar1");
            modifyCalDelegates(cal1);
        }
        function modifyCalDelegates(cal) {
            //we need to modify the original delegate of the month cell.
            cal._cell$delegates =
            {
                mouseover: Function.createDelegate(cal, cal._cell_onmouseover),
                mouseout: Function.createDelegate(cal, cal._cell_onmouseout),

                click: Function.createDelegate(cal, function (e) {

                    e.stopPropagation();
                    e.preventDefault();

                    if (!cal._enabled) return;

                    var target = e.target;
                    var visibleDate = cal._getEffectiveVisibleDate();
                    Sys.UI.DomElement.removeCssClass(target.parentNode, "ajax__calendar_hover");
                    switch (target.mode) {
                        case "prev":
                        case "next":
                            cal._switchMonth(target.date);
                            break;
                        case "title":
                            switch (cal._mode) {
                                case "days": cal._switchMode("months"); break;
                                case "months": cal._switchMode("years"); break;
                            }
                            break;
                        case "month":
                            //if the mode is month, then stop switching to day mode.
                            if (target.month == visibleDate.getMonth()) {
                                //this._switchMode("days");
                            }
                            else {
                                cal._visibleDate = target.date;
                                //this._switchMode("days");
                            }
                            cal.set_selectedDate(target.date);
                            cal._switchMonth(target.date);
                            cal._blur.post(true);
                            cal.raiseDateSelectionChanged();
                            break;

                        case "year":
                            if (target.date.getFullYear() == visibleDate.getFullYear()) {
                                cal._switchMode("months");
                            }
                            else {
                                cal._visibleDate = target.date;
                                cal._switchMode("months");
                            }
                            break;

                            //                case "day":
                            //                    this.set_selectedDate(target.date);
                            //                    this._switchMonth(target.date);
                            //                    this._blur.post(true);
                            //                    this.raiseDateSelectionChanged();
                            //                    break;
                        case "today":
                            cal.set_selectedDate(target.date);
                            cal._switchMonth(target.date);
                            cal._blur.post(true);
                            cal.raiseDateSelectionChanged();
                            break;
                    }

                }

                 )
            }

        }

        function onCalendarShown(sender, args) {
            //set the default mode to month
            sender._switchMode("months", true);
            changeCellHandlers(cal1);

        }

        function changeCellHandlers(cal) {
            if (cal._monthsBody) {
                //remove the old handler of each month body.
                for (var i = 0; i < cal._monthsBody.rows.length; i++) {
                    var row = cal._monthsBody.rows[i];
                    for (var j = 0; j < row.cells.length; j++) {
                        $common.removeHandlers(row.cells[j].firstChild, cal._cell$delegates);
                    }
                }
                //add the new handler of each month body.
                for (var i = 0; i < cal._monthsBody.rows.length; i++) {
                    var row = cal._monthsBody.rows[i];
                    for (var j = 0; j < row.cells.length; j++) {
                        $addHandlers(row.cells[j].firstChild, cal._cell$delegates);
                    }
                }
            }
        }
    </script>
    <script type="text/javascript">
        function doClick(buttonName, e) {
            //the purpose of this function is to allow the enter key to
            //point to the correct button to click.
            var key;

            if (window.event)
                key = window.event.keyCode;     //IE
            else
                key = e.which;     //firefox

            if (key == 13) {
                //Get the button the user wants to have clicked
                var btn = document.getElementById(buttonName);
                if (btn != null) { //If we find the button click it
                    btn.click();
                    event.keyCode = 0
                }
            }
        }
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <b>Income Tax Reports </b>
                <br />
                <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Reports
            </div>
            <div style="text-align: left;">
                <table width="100%">
                    <tr>
                        <td align="center" style="width: 8%"></td>
                        <td align="left" rowspan="8" style="width: 9%" valign="top">
                            <asp:RadioButtonList ID="rbtnReportType" AutoPostBack="true" runat="server" OnSelectedIndexChanged="rbtnReportType_SelectedIndexChanged">
                                <asp:ListItem Selected="True">Income Tax Monthly</asp:ListItem>
                                <asp:ListItem style="display: none">Income Tax Detail</asp:ListItem>
                                <asp:ListItem style="display: none">Computation Form</asp:ListItem>
                                <asp:ListItem style="display: none">Form 16</asp:ListItem>
                                <asp:ListItem style="display: none">Form 27A</asp:ListItem>
                                <asp:ListItem>Form 55</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                        <td colspan="2" align="center">Report Format :
                            <td>
                                <asp:RadioButtonList ID="RadioButtonList2" runat="server" RepeatDirection="Horizontal">
                                    <asp:ListItem Selected="True">PDF</asp:ListItem>
                                    <asp:ListItem>Word</asp:ListItem>
                                    <asp:ListItem>Excel</asp:ListItem>
                                </asp:RadioButtonList>
                            </td>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 8%" align="center"></td>
                        <td colspan="2" align="center">&nbsp; &nbsp;&nbsp;&nbsp;<asp:Label ID="lblDate" runat="server" Visible="true" Text="Salary Month :">
                        </asp:Label>
                        </td>
                        <td colspan="1">
                            <%--<uc1:EntryDate  ID="MonthDate" runat="server" />--%>
                            <asp:TextBox ID="MonthDate" runat="server" ToolTip="Click to Select Salary Month"></asp:TextBox>
                            <cc1:CalendarExtender ID="calMonthDate" runat="server" TargetControlID="MonthDate"
                                Format="MMM-yyyy" OnClientShown="onCalendarShown" BehaviorID="calendar1">
                            </cc1:CalendarExtender>
                        </td>
                    </tr>
                    <tr>
                        <td align="center" style="width: 8%"></td>
                        <td colspan="3">
                            <table border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td>
                                        <asp:Label ID="lblFromDate" Visible="false" runat="server" Text="From"></asp:Label>&nbsp;
                                    </td>
                                    <td>
                                        <%-- <uc1:EntryDate  Visible="false" ID="txtFromDate" runat="server" />--%>
                                        <asp:TextBox ID="txtFromDate" runat="server" Visible="false"></asp:TextBox>
                                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate"
                                            Format="dd-MMM-yyyy">
                                        </cc1:CalendarExtender>
                                    </td>
                                    <td>
                                        <asp:Label Visible="false" ID="lblTo" runat="server" Text="To"></asp:Label>
                                    </td>
                                    <td>
                                        <%-- <uc1:EntryDate  ID="txtToDate"  Visible="false" runat="server" />--%>
                                        <asp:TextBox ID="txtToDate" runat="server" Visible="false"></asp:TextBox>
                                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy">
                                        </cc1:CalendarExtender>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td align="center" style="width: 8%; height: 24px;"></td>
                        <td colspan="3" style="height: 24px">
                            <asp:DropDownList Visible="false" ID="ddlFrom" runat="server">
                                <asp:ListItem>2010</asp:ListItem>
                                <asp:ListItem>2011</asp:ListItem>
                            </asp:DropDownList>
                            <asp:DropDownList Visible="false" ID="ddlTo" runat="server">
                                <asp:ListItem>2011</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" style="width: 8%; height: 18px"></td>
                        <td style="width: 6%; height: 18px" valign="top">
                            <asp:Label ID="lblEmpID" runat="server" Text="Employee ID:" Visible="False"></asp:Label>
                        </td>
                        <td style="width: 2%; height: 18px" valign="middle">
                            <asp:TextBox ID="txtEmployeeID" Visible="false" runat="server"></asp:TextBox>
                        </td>
                        <td style="width: 20%; height: 18px" align="left" valign="middle"></td>
                    </tr>
                    <tr>
                        <td align="center" style="width: 8%; height: 18px"></td>
                        <td style="width: 6%; height: 18px">
                            <asp:Label ID="labReportType" runat="server" Text="Report Type:" Visible="False"></asp:Label>
                        </td>
                        <td style="width: 2%; height: 18px">
                            <asp:DropDownList ID="ddlReportType" runat="server" Visible="False" Width="155px">
                                <asp:ListItem></asp:ListItem>
                                <asp:ListItem>TAX PAYABLE</asp:ListItem>
                                <asp:ListItem>TAX NOT PAYABLE</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td style="width: 20%; height: 18px"></td>
                    </tr>
                    <tr>
                        <td align="center" style="width: 8%; height: 18px"></td>
                        <td style="width: 6%; height: 18px"></td>
                        <td style="width: 2%; height: 18px"></td>
                        <td style="width: 20%; height: 18px"></td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click"
                CssClass="ItDoseButton" ToolTip="Click to Search" />
        </div>
    </div>
</asp:Content>