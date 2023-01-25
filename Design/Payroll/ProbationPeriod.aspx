<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="ProbationPeriod.aspx.cs" Inherits="Design_Payroll_ProbationPeriod" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Payroll/UserControl/MonthYear.ascx" TagName="EntryDate"
    TagPrefix="uc2" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
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
    <script type="text/javascript">
        var calendarID = '';
        function onCalendarShown(sender, e) {
            calendarID = sender._id;
            var cal = $find(sender._id);
            //Setting the default mode to month
            cal._switchMode("months", true);

            //Iterate every month Item and attach click event to it
            if (cal._monthsBody) {
                for (var i = 0; i < cal._monthsBody.rows.length; i++) {
                    var row = cal._monthsBody.rows[i];
                    for (var j = 0; j < row.cells.length; j++) {
                        Sys.UI.DomEvent.addHandler(row.cells[j].firstChild, "click", call);
                    }
                }
            }
        }

        function onCalendarHidden(sender, e) {

            calendarID = sender._id;
            var cal = $find(sender._id);
            //Iterate every month Item and remove click event from it
            if (cal._monthsBody) {
                for (var i = 0; i < cal._monthsBody.rows.length; i++) {
                    var row = cal._monthsBody.rows[i];
                    for (var j = 0; j < row.cells.length; j++) {
                        Sys.UI.DomEvent.removeHandler(row.cells[j].firstChild, "click", call);
                    }
                }
            }
        }

        function call(eventElement) {
            var target = eventElement.target;
            switch (target.mode) {
                case "month":
                    var cal = $find(calendarID);
                    cal._visibleDate = target.date;
                    cal.set_selectedDate(target.date);
                    cal._switchMonth(target.date);
                    cal._blur.post(true);
                    cal.raiseDateSelectionChanged();
                    break;
            }
            calendarID = '';
        }
    </script>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Probation Period </b>
            <br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-4"></div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Probation Period
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <uc2:EntryDate ID="txtDate" runat="server" />
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Status
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:DropDownList ID="ddlStatus" runat="server">
                                <asp:ListItem>ALL</asp:ListItem>
                                <asp:ListItem Value="1">Complete</asp:ListItem>
                                <asp:ListItem Value="0">Incomplete</asp:ListItem>
                                <asp:ListItem Value="2">Extended</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-4">
                            <asp:Button ID="btnSearch" runat="server" OnClick="btnSearch_Click" Text="Search"
                                CssClass="ItDoseButton" ValidationGroup="v1" ToolTip="Click to Search" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Results
            </div>
            <div class="row">
                <div class="col-md-24" align="center">
                    <asp:GridView ID="EmpGrid" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle"
                        OnRowCommand="grirecord_RowCommand" OnRowDataBound="EmpGrid_RowDataBound">
                        <Columns>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkselect" runat="server" OnCheckedChanged="chkselect_CheckedChanged" AutoPostBack="true" />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Employee&nbsp;ID" Visible="true">
                                <ItemTemplate>
                                    <asp:Label ID="lblid" runat="server" Text='<%#Eval("Employee_ID")%>' Visible="true"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Employee&nbsp;Name">
                                <ItemTemplate>
                                    <%#Eval("Name")%>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="240px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Designation">
                                <ItemTemplate>
                                    <%#Eval("Desi_Name")%>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Department">
                                <ItemTemplate>
                                    <%#Eval("Dept_Name")%>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="D.O.J.">
                                <ItemTemplate>
                                    <%#Eval("DOJ")%>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Confirm&nbsp;Date">
                                <ItemTemplate>

                                    <asp:TextBox ID="txtDate" runat="server" Width="90px" ToolTip="Select Confirm Date"></asp:TextBox>
                                    <cc1:CalendarExtender ID="calDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtDate" PopupButtonID="txtDate">
                                    </cc1:CalendarExtender>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="45px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Probation&nbsp;Period">
                                <ItemTemplate>
                                    <asp:Label ID="lblDOJ" Visible="False" Text='<%#Eval("DOJ") %>' runat="server"></asp:Label>
                                    <asp:Label ID="lblProbationPeriodComplet" Text='<%#Eval("ProbationPeriodCompleteDate") %>'
                                        Visible="False" runat="server"></asp:Label>
                                    <asp:Label ID="lblEmployeeID" Visible="False" runat="server" Text='<%#Eval("Employee_ID") %>'></asp:Label>
                                    <asp:TextBox ID="txtProbationPeriod" Text='<%#Eval("ProbationPeriod") %>' runat="server"
                                        Width="60" MaxLength="2" ToolTip="Enter Probation Period"></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="fc2" runat="server" TargetControlID="txtProbationPeriod"
                                        FilterType="numbers">
                                    </cc1:FilteredTextBoxExtender>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Approve" Visible="false">
                                <ItemTemplate>
                                    <%--     <% if (ViewState["Permission"].ToString() == "Cancel" || ViewState["Permission"].ToString() == "All")
                                                    {%>--%>
                                    <asp:ImageButton ID="imbPrint" runat="server" CausesValidation="false" CommandArgument='<%# Eval("Employee_ID")%>'
                                        CommandName="Post" ImageUrl="~/Images/Post.gif" />
                                    <%-- <%} %>--%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
            <div class="row">
                <div class="col-md-24" align="center">
                    <asp:Button ID="btnSave" Visible="False" runat="server" OnClick="btnSave_Click" Text="Save"
                        CssClass="ItDoseButton" Style="margin-top: 7px; width: 100px" />
                </div>
            </div>

        </div>
    </div>
</asp:Content>
