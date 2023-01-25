<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="Relievingletter.aspx.cs" Inherits="Design_Payroll_Relievingletter" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        function CalculateRemuneration() {

            var basic = document.getElementById("ctl00$ContentPlaceHolder1$txtBasic").value;

            var hra = document.getElementById("ctl00$ContentPlaceHolder1$txtHRA").value;
            var Conveyance = document.getElementById("ctl00$ContentPlaceHolder1$txtConvAllowance").value;

            if (basic == "")
            { basic = "0"; }
            if (Conveyance == "")
            { Conveyance = "0"; }
            if (hra == "")
            { hra = "0"; }
            //alert(Conveyance);
            var Total = eval(basic) + eval(hra) + eval(Conveyance);
            //alert(Total);
            document.getElementById("ctl00$ContentPlaceHolder1$txtTotalRemuneration").value = Total;

        }
    </script>
    <script type="text/javascript">

        function validatespace() {
            var AuthorityName = $('#<%=txtAuthorityName.ClientID %>').val();
            var AuthorityDesignation = $('#<%=txtAuthorityDesignation.ClientID %>').val();
            var AuthorityDepartment = $('#<%=txtAuthorityDepartment.ClientID %>').val();
            if (AuthorityName.charAt(0) == ' ' || AuthorityName.charAt(0) == '.') {
                $('#<%=txtAuthorityName.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                AuthorityName.replace(AuthorityName.charAt(0), "");
                return false;
            }
            if (AuthorityDesignation.charAt(0) == ' ' || AuthorityDesignation.charAt(0) == '.') {
                $('#<%=txtAuthorityDesignation.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                AuthorityDesignation.replace(AuthorityDesignation.charAt(0), "");
                return false;
            }
            if (AuthorityDepartment.charAt(0) == ' ' || AuthorityDepartment.charAt(0) == '.') {
                $('#<%=txtAuthorityDepartment.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                AuthorityDepartment.replace(AuthorityDepartment.charAt(0), "");
                return false;
            }
            else {
                $('#<%=lblmsg.ClientID %>').text('');
                return true;
            }

        }
        function check(e) {
            var keynum
            var keychar
            var numcheck
            // For Internet Explorer
            if (window.event) {
                keynum = e.keyCode
            }
                // For Netscape/Firefox/Opera
            else if (e.which) {
                keynum = e.which
            }
            keychar = String.fromCharCode(keynum)
            var AuthorityName = $('#<%=txtAuthorityName.ClientID %>').val();
            var AuthorityDesignation = $('#<%=txtAuthorityDesignation.ClientID %>').val();
            var AuthorityDepartment = $('#<%=txtAuthorityDepartment.ClientID %>').val();
            if (AuthorityName.charAt(0) == ' ') {
                $('#<%=txtAuthorityName.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space');
                return false;
            }
            if (AuthorityDesignation.charAt(0) == ' ') {
                $('#<%=txtAuthorityDesignation.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space');
                return false;
            }
            if (AuthorityDepartment.charAt(0) == ' ') {
                $('#<%=txtAuthorityDepartment.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space');
                return false;
            }
            //List of special characters you want to restrict
            if (keychar == "'" || keychar == "`" || keychar == "!" || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "45") || (keynum >= "91" && keynum <= "95") || (keynum >= "49" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }

            else {
                return true;
            }
        }
        function displayValidationResult() {
            if (typeof (Page_Validators) == "undefined") return;
            var AuthorityName = document.getElementById("<%=reqAuthorityName.ClientID%>");
            var AuthorityDesignation = document.getElementById("<%=reqAuthorityDesignation.ClientID%>");
            var LblName = document.getElementById("<%=lblmsg.ClientID%>");
            ValidatorValidate(AuthorityName);
            if (!AuthorityName.isvalid) {
                LblName.innerText = AuthorityName.errormessage;
                return false;
            }

            ValidatorValidate(AuthorityDesignation);
            if (!AuthorityDesignation.isvalid) {
                LblName.innerText = AuthorityDesignation.errormessage;
                return false;
            }

        }
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Relieving Letter </b>
            <br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory" id="tbl1" runat="server">
       
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                Employee ID 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtEmployeeID" runat="server" MaxLength="20" TabIndex="1"
                                ToolTip="Enter Employee ID"></asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Employee Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtEmployeeName" runat="server" MaxLength="50" TabIndex="2"
                                ToolTip="Enter Employee Name"></asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click"
                                CausesValidation="False" CssClass="ItDoseButton" TabIndex="3" ToolTip="Click to Search" Style="width: 100px;" />
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
                <div class="col-md-1"></div>
                <div class="col-md-22" align="center">
                    <asp:GridView ID="EmpGrid" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                        OnRowCommand="EmpGrid_RowCommand1">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="EmployeeID" HeaderText="Employee&nbsp;ID" ReadOnly="true">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Name" HeaderText="Employee&nbsp;Name" ReadOnly="true">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="350px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="DateOfLeaving" HeaderText="Date&nbsp;Of&nbsp;Leaving"
                                ReadOnly="true">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Select">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbSelect" ToolTip="Click to Select" runat="server" ImageUrl="~/Images/Post.gif"
                                        CausesValidation="false" CommandArgument='<%# Eval("EmployeeID")%>' CommandName="Select" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
        <asp:Panel ID="pnlHide" runat="server" Visible="false">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Employee Detail
                </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22" align="center">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Employee ID 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:Label ID="lblEmployeeID" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Employee Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:Label ID="LblName" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Date Of Leaving
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:Label ID="LblDol" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                            </div>
                            </div>
                            <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Issue Date
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtissue" runat="server" TabIndex="4" ToolTip="Select Issue Date"></asp:TextBox>
                                <cc1:CalendarExtender ID="calucDate" runat="server" TargetControlID="txtissue" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Resignation Date
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                 <asp:TextBox ID="txtresignationdate" runat="server" TabIndex="5" ToolTip="Select Resignation Date"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtresignationdate"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Authority Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                 <asp:TextBox ID="txtAuthorityName" TabIndex="6" ToolTip="Enter Authority Name"
                                runat="server" CssClass="requiredField" MaxLength="100" onkeypress="return check(event)"
                                onkeyup="validatespace();"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="reqAuthorityName" runat="server" ControlToValidate="txtAuthorityName"
                                ErrorMessage="Enter Authority Name" Display="None" SetFocusOnError="true"></asp:RequiredFieldValidator>
                            </div>
                            </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Authority Deg
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtAuthorityDesignation" Text="HR-Manager" runat="server"
                                CssClass="requiredField" TabIndex="7" ToolTip="Enter Authority Designation" MaxLength="50"
                                onkeypress="return check(event)" onkeyup="validatespace();"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="reqAuthorityDesignation" runat="server" ControlToValidate="txtAuthorityDesignation"
                                ErrorMessage="Enter Authority Designation" Display="None" SetFocusOnError="true"></asp:RequiredFieldValidator>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Authority Dept
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtAuthorityDepartment" TabIndex="8" ToolTip="Enter Auhtority Department"
                                Text="HR-Department" runat="server" MaxLength="50" onkeypress="return check(event)"
                                onkeyup="validatespace();"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
               
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:Button ID="btnSave" CssClass="ItDoseButton" runat="server" Text="Save"
                    ValidationGroup="v1" OnClick="btnSave_Click" ToolTip="Click to Save" TabIndex="9"
                    OnClientClick="return displayValidationResult();" Style="margin-top: 7px; width: 100px" />
                <asp:Button ID="btnUpdate" CssClass="ItDoseButton" runat="server" Text="Update" ValidationGroup="v1"
                    OnClick="btnUpdate_Click" ToolTip="Click to Update" TabIndex="10" OnClientClick="return displayValidationResult();" Style="margin-top: 7px; width: 100px" />
                <asp:Button ID="btncancel" ToolTip="Click to Cancel" CssClass="ItDoseButton" runat="server"
                    Text="Cancel" OnClick="btncancel_Click" TabIndex="11" Style="margin-top: 7px; width: 100px" />
            </div>
        </asp:Panel>
    </div>
</asp:Content>
