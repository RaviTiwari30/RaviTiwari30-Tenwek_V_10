<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="Employee_Verification.aspx.cs" Inherits="Design_Payroll_employee_verification" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
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
                //alert(Conveyance);
                var Total = eval(basic) + eval(hra) + eval(Conveyance);
            //alert(Total);
            document.getElementById("ctl00$ContentPlaceHolder1$txtTotalRemuneration").value = Total;

        }
    </script>
    <script src="../../Scripts/Search.js" type="text/javascript"></script>

    <script type="text/javascript">

        function validatespace() {
            var card = $('#<%=txtEmployeeName.ClientID %>').val();
            if (card.charAt(0) == ' ' || card.charAt(0) == '.' || card.charAt(0) == ',') {
                $('#<%=txtEmployeeName.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                card.replace(card.charAt(0), "");
                return false;
            }
            else {
                $('#<%=lblmsg.ClientID %>').text('');
                return true;
            }

        }
        function validatespace1() {
            var card = $('#<%=txtEmployeeID.ClientID %>').val();
            if (card.charAt(0) == ' ' || card.charAt(0) == '.' || card.charAt(0) == ',') {
                $('#<%=txtEmployeeID.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                card.replace(card.charAt(0), "");
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
            var card = $('#<%=txtEmployeeName.ClientID %>').val();
            if (card.charAt(0) == ' ') {
                $('#<%=txtEmployeeName.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space');
                return false;
            }
            //List of special characters you want to restrict
            if (keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || keychar == "." || keychar == "/" || (keynum >= "40" && keynum <= "45") || (keynum >= "91" && keynum <= "95") || (keynum >= "58" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }

            else {
                return true;
            }
        }
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Employee Verification </b>
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
                        <div class="col-md-4">
                            <label class="pull-left">
                                Employee ID 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtEmployeeID" TabIndex="1" ToolTip="Enter Employee ID" runat="server" onkeypress="return check(event)" MaxLength="10" onkeyup="validatespace1();"></asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Employee Name 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtEmployeeName" TabIndex="2" ToolTip="Enter Employee Name" MaxLength="50" runat="server" onkeypress="return check(event)"
                                onkeyup="validatespace();"></asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <asp:Button ID="btnSearch" TabIndex="3" ToolTip="Click to Search" runat="server" CssClass="ItDoseButton" Text="Search" OnClick="btnSearch_Click" />
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
                <div class="col-md-22" align="center">
                    <asp:GridView ID="EmpGrid" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                        OnRowDataBound="EmpGrid_RowDataBound" AllowPaging="True"
                        OnPageIndexChanging="EmpGrid_PageIndexChanging" Width="936px">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="Employee_ID" HeaderText="Employee ID" ReadOnly="True">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Name" HeaderText="Employee&nbsp;Name" ReadOnly="True">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Verifications">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="600px" />
                                <ItemTemplate>
                                    <asp:CheckBoxList ID="Chk1" runat="server" RepeatDirection="Horizontal">
                                    </asp:CheckBoxList>
                                    <asp:Label ID="lblEmployeeID" runat="server" Visible="false" Text='<%#Eval("Employee_ID") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" align="center">
            <asp:Button ID="BtnSave" runat="server" Text="Save" Font-Bold="True" OnClick="BtnSave_Click"
                Visible="False" ToolTip="Click to Save" CssClass="ItDoseButton" Style="margin-top: 7px; width: 100px"  />

        </div>
    </div>
</asp:Content>
