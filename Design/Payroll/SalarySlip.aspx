<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="SalarySlip.aspx.cs" Inherits="Design_Payroll_SalarySlip" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    
    <script type="text/javascript">
        $(document).ready(function () {
            var chk = $("#<%=rbtnReportType.ClientID%>").find("input[name='<%=rbtnReportType.UniqueID%>']:radio:checked").val();
            if (chk == "1") {
                $(".emp").show();
                $(".dep").hide();
                $(".Bank").hide();
                $(".excel").show();
            }
            else if (chk == "2") {
                $(".emp").hide();
                $(".dep").hide();
                $(".Bank").hide();
                $(".excel").show();
            }
            else if (chk == "3") {
                $(".emp").hide();
                $(".dep").show();
                $(".Bank").hide();
                $(".excel").show();
            }
            else if (chk == "4") {
                $(".emp").hide();
                $(".dep").hide();
                $(".Bank").hide();
                $(".excel").show();
            }
            else if (chk == "5") {
                $(".emp").hide();
                $(".dep").hide();
                $(".Bank").show();
                $(".excel").show();
            }
            else if (chk == "6") {
                $(".emp").hide();
                $(".dep").hide();
                $(".Bank").show();
                $(".excel").show();
            }
            else if (chk == "7") {
                $(".emp").hide();
                $(".dep").hide();
                $(".Bank").hide();
                $(".excel").show();
            }
            else if (chk == "8") {
                $(".emp").hide();
                $(".dep").hide();
                $(".Bank").hide();
                $(".excel").hide();
            }
            else if (chk == "9") {
                $(".emp").hide();
                $(".dep").hide();
                $(".Bank").hide();
                $(".excel").show();

            }
            else if (chk == "10") {
                $(".emp").hide();
                $(".dep").hide();
                $(".Bank").hide();
                $(".excel").hide();

            }
            else if (chk == "11") {
                $(".emp").hide();
                $(".dep").hide();
                $(".Bank").hide();
                $(".excel").hide();

            }
            else {

                $(".emp").hide();
                $(".dep").hide();
                $(".Bank").hide();
                $(".excel").show();
            }

            $("#<%=rbtnReportType.ClientID%>").click(function () {
                var rbvalue = $('#<%=rbtnReportType.ClientID %> input[type=radio]:checked').val();
                //  var rbvalue = $("input[name='<%=rbtnReportType.UniqueID%>']:radio:checked").val();
                if (rbvalue == "1") {
                    $(".emp").show();
                    $(".dep").hide();
                    $(".Bank").hide();
                    $(".excel").show();
                }
                else if (rbvalue == "2") {
                    $(".emp").hide();
                    $(".dep").hide();
                    $(".Bank").hide();
                    $(".excel").show();
                }
                else if (rbvalue == "3") {
                    $(".emp").hide();
                    $(".dep").show();
                    $(".Bank").hide();
                    $(".excel").show();
                }
                else if (rbvalue == "4") {
                    $(".emp").hide();
                    $(".dep").hide();
                    $(".Bank").hide();
                    $(".excel").show();
                }
                else if (rbvalue == "5") {
                    $(".emp").hide();
                    $(".dep").hide();
                    $(".Bank").show();
                    $(".excel").show();
                }
                else if (rbvalue == "6") {
                    $(".emp").hide();
                    $(".dep").hide();
                    $(".Bank").show();
                    $(".excel").show();
                }
                else if (rbvalue == "7") {
                    $(".emp").hide();
                    $(".dep").hide();
                    $(".Bank").hide();
                    $(".excel").show();
                }
                else if (rbvalue == "8") {
                    $(".emp").hide();
                    $(".dep").hide();
                    $(".Bank").hide();
                    $(".excel").hide();
                }
                else if (rbvalue == "9") {
                    $(".emp").hide();
                    $(".dep").hide();
                    $(".Bank").hide();
                    $(".excel").show();
                }
                else if (rbvalue == "10") {
                    $(".emp").hide();
                    $(".dep").hide();
                    $(".Bank").hide();
                    $(".excel").hide();
                }
                else if (rbvalue == "11") {
                    $(".emp").hide();
                    $(".dep").hide();
                    $(".Bank").hide();
                    $(".excel").hide();
                }
                else {
                    $(".emp").hide();
                    $(".dep").hide();
                    $(".Bank").hide();
                    $(".excel").show();
                }
            });

        });
    </script>
    
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
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Salary Slip</b><br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                &nbsp;
            </div>
            <div class="content">
                <div style="text-align: left;">
                    <table width="100%">
                        <tr>
                            <td style="width: 18%" align="right">Select Salary Month :
                            </td>
                            <td style="width: 31%">
                                <%--<uc1:entrydate id="SalaryMonth" runat="server" />
                                --%>
                                <asp:TextBox ID="SalaryMonth" runat="server"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server"
                                    TargetControlID="SalaryMonth" Format="MMM-yyyy" OnClientShown="onCalendarShown" BehaviorID="calendar1">
                                </cc1:CalendarExtender>
                            </td>
                            <td style="width: 20%" align="right" class="excel">Report Format :
                            </td>
                            <td align="left" style="width: 20%" class="excel">
                                <asp:RadioButtonList ID="RadioButtonList1" runat="server" RepeatDirection="Horizontal">
                                    <asp:ListItem Selected="True">PDF</asp:ListItem>
                                    <asp:ListItem>Word</asp:ListItem>
                                </asp:RadioButtonList>
                            </td>
                            <td style="width: 20%"></td>
                            <td style="width: 20%"></td>
                        </tr>
                        <tr>
                            <td style="width: 18%" align="right">&nbsp;
                            </td>
                            <td style="width: 31%">&nbsp;
                            </td>
                            <td style="width: 20%" align="right">&nbsp;
                            </td>
                            <td align="left" style="width: 20%">&nbsp;
                            </td>
                            <td style="width: 20%">&nbsp;
                            </td>
                            <td style="width: 20%">&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td align="center" style="width: 18%; height: 18px" rowspan="10"></td>
                            <td style="width: 31%; height: 18px" rowspan="10">
                                <asp:RadioButtonList ID="rbtnReportType" runat="server" OnSelectedIndexChanged="rbtnReportType_SelectedIndexChanged"
                                    AutoPostBack="False" Width="234px">
                                    <asp:ListItem Selected="True" Value="1">Employee Wise Salary Slip</asp:ListItem>
                                    <asp:ListItem Value="2">Department Wise Employee</asp:ListItem>
                                    <asp:ListItem Value="3">Department Wise Summary</asp:ListItem>
                                    <asp:ListItem Value="4">All Department Summary</asp:ListItem>
                                    <asp:ListItem Value="5">Bank Letter Detail</asp:ListItem>
                                    <asp:ListItem Value="6">Bank Letter (Excel Format)</asp:ListItem>
                                    <asp:ListItem Value="7">Cash/Cheque Salary Detail</asp:ListItem>
                                    <asp:ListItem Value="8">Salary Sheet(Excel Format)</asp:ListItem>
                                    <asp:ListItem Value="9" style="display: none">Salary Sheet</asp:ListItem>
                                    <asp:ListItem Value="10">Class Summary</asp:ListItem>
                                    <asp:ListItem Value="11">Class Summary (Excel Format)</asp:ListItem>
                                </asp:RadioButtonList>
                            </td>
                        </tr>
                        <tr class="emp">
                            <td valign="top" style="width: 20%; height: 18px" align="right">
                                <asp:Label ID="lblempid" Text="Employee ID :&nbsp;" runat="server"></asp:Label>
                            </td>
                            <td colspan="2" style="height: 18px" valign="top">
                                <asp:TextBox ID="txtEmpID" MaxLength="20" runat="server" ToolTip="Enter Employee ID"
                                    AutoCompleteType="disabled"></asp:TextBox>
                            </td>
                        </tr>
                        <tr class="dep">
                            <td style="width: 20%; height: 18px" align="right" valign="top">
                                <asp:Label ID="lblDept" runat="server" Text="Department :&nbsp;"></asp:Label>
                            </td>
                            <td colspan="2" style="height: 18px" valign="top">
                                <asp:DropDownList ID="ddlDepartment" runat="server" Width="235px" CssClass="inputbox"
                                    ToolTip="Select Department">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr class="let">
                            <td style="width: 20%; height: 18px" align="right" valign="top">
                                <asp:Label ID="lblLetterNo" runat="server" Text="Letter No. :&nbsp;" Visible="False"></asp:Label>
                            </td>
                            <td colspan="2" style="height: 18px" valign="top">
                                <asp:TextBox ID="txtLetterNo" runat="server" Visible="False"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="fc" runat="server" FilterType="numbers" TargetControlID="txtLetterNo">
                                </cc1:FilteredTextBoxExtender>
                            </td>
                            <td style="height: 18px" valign="top"></td>
                        </tr>
                        <tr class="Bank">
                            <td style="width: 20%; height: 18px" align="right">
                                <asp:Label ID="lblBankName" runat="server" Text="Bank :&nbsp;"></asp:Label>
                            </td>
                            <td colspan="2" style="height: 18px">
                                <asp:DropDownList ID="ddlBankName" Width="250px" ToolTip="Select Bank" runat="server">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 20%; height: 18px" align="right" valign="top">&nbsp;
                            </td>
                            <td colspan="2" style="height: 18px" valign="top">&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 20%; height: 18px" align="right" valign="top">&nbsp;
                            </td>
                            <td colspan="2" style="height: 18px" valign="top">&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 20%; height: 18px" align="right" valign="top">&nbsp;
                            </td>
                            <td colspan="2" style="height: 18px" valign="top">&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 20%; height: 18px" align="right" valign="top">&nbsp;
                            </td>
                            <td colspan="2" style="height: 18px" valign="top">&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 20%; height: 18px" align="right" valign="top">&nbsp;
                            </td>
                            <td colspan="2" style="height: 18px" valign="top">&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td align="center" style="width: 18%; height: 18px">&nbsp;
                            </td>
                            <td style="width: 31%; height: 18px">&nbsp;
                            </td>
                            <td style="width: 20%; height: 18px" align="right" valign="top">&nbsp;
                            </td>
                            <td colspan="2" style="height: 18px" valign="top">&nbsp;
                            </td>
                            <td style="width: 20%; height: 18px">&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td align="center" style="width: 18%; height: 18px"></td>
                            <td style="width: 31%; height: 18px"></td>
                            <td style="width: 20%; height: 18px"></td>
                            <td style="width: 20%; height: 18px"></td>
                            <td style="width: 20%; height: 18px"></td>
                            <td style="width: 20%; height: 18px"></td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click"
                CssClass="ItDoseButton" ToolTip="Click to Search" />
        </div>
    </div>
</asp:Content>