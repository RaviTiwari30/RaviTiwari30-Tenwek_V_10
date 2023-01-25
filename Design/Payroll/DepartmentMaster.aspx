<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="DepartmentMaster.aspx.cs" Inherits="Design_Payroll_DepartmentMaster" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
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
        $(document).ready(function () {
            $("#<%=txtDept.ClientID %>").focus();
        });
            function displayValidationResult() {
                if (typeof (Page_Validators) == "undefined") return;
                var Name = document.getElementById("<%=reqName.ClientID%>");
                var Number = document.getElementById("<%=reqNumber.ClientID%>");
                var LblName = document.getElementById("<%=lblmsg.ClientID%>");
                ValidatorValidate(Name);
                if (!Name.isvalid) {
                    LblName.innerText = Name.errormessage;
                    return false;
                }

                ValidatorValidate(Number);
                if (!Number.isvalid) {
                    LblName.innerText = Number.errormessage;
                    return false;
                }

            }
    </script>
    <script type="text/javascript">

        function validatespace() {
            var card = $('#<%=txtDept.ClientID %>').val();
            if (card.charAt(0) == ' ' || card.charAt(0) == '.') {
                $('#<%=txtDept.ClientID %>').val('');
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
            var card = $('#<%=txtDept.ClientID %>').val();
                if (card.charAt(0) == ' ') {
                    $('#<%=txtDept.ClientID %>').val('');
                    $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space');
                    return false;
                }
                //List of special characters you want to restrict
                if (keychar == "'" || keychar == "`" || keychar == "!" || keychar == "~" || keychar == "." || keychar == ";" || (keynum >= "40" && keynum <= "44") || (keynum >= "91" && keynum <= "95") || (keynum >= "49" && keynum <= "64") || (keynum >= "34" && keynum <= "37") || (keynum >= "123" && keynum <= "125")) {
                    return false;
                }

                else {
                    return true;
                }
            }
    </script>

    <Ajax:ScriptManager ID="sm" runat="server" />
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Department Master </b>
            <br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Department Details
            </div>
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:TextBox ID="txtDept" runat="server" AutoCompleteType="Disabled" CssClass="requiredField"
                                MaxLength="50" TabIndex="1" ToolTip="Enter Department" onkeypress="return check(event)"
                                onkeyup="validatespace();"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Employee Required
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:TextBox ID="txtempreq" Text="0" runat="server" CssClass="requiredField" MaxLength="4" TabIndex="2"
                                ToolTip="Enter Employee Required" AutoCompleteType="Disabled"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ft1" runat="server" TargetControlID="txtempreq"
                                FilterType="Numbers">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left">
                                Is Active
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:RadioButtonList ID="rblActive" runat="server" RepeatDirection="Horizontal" TabIndex="3"
                                ToolTip="Select Active">
                                <asp:ListItem Selected="True" Value="1">Active</asp:ListItem>
                                <asp:ListItem Value="0">Deactive</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <asp:Label ID="lblDeptHead" Text="Department Head" runat="server" Visible="false" CssClass="pull-left"></asp:Label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:DropDownList ID="ddlDeptHeadName" runat="server" Visible="false" CssClass="requiredField"></asp:DropDownList>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-22" align="center">
                    <asp:Button ID="btnSave" runat="server" TabIndex="4" ToolTip="Click to Save" CssClass="ItDoseButton"
                        Text="Save" OnClick="btnSave_Click" OnClientClick="return displayValidationResult();"
                        ValidationGroup="v1" Style="margin-top: 7px; width: 100px;" />
                    <asp:Button ID="btnUpdate" runat="server" CssClass="ItDoseButton"
                        TabIndex="5" ToolTip="Click to Update" OnClick="btnUpdate_Click" Text="Update"
                        ValidationGroup="v1" OnClientClick="return displayValidationResult();" Style="margin-top: 7px; width: 100px;" />
                    <asp:Button ID="btnCancel" runat="server" CssClass="ItDoseButton" TabIndex="6" ToolTip="Click to Cancel"
                        OnClick="btncancel_Click" Text="Cancel" Style="margin-top: 7px; width: 100px;" />
                    <asp:RequiredFieldValidator ControlToValidate="txtDept" SetFocusOnError="true"
                        ID="reqName" runat="server" Display="None" ErrorMessage="Enter Department Name"
                        ValidationGroup="v1"></asp:RequiredFieldValidator>
                    <asp:RequiredFieldValidator ControlToValidate="txtempreq" SetFocusOnError="true"
                        ID="reqNumber" runat="server" Display="None" ErrorMessage="Enter Number Of Employees"
                        ValidationGroup="v1"></asp:RequiredFieldValidator>

                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Department List
            </div>
            <div class="col-md-22" align="center">
                <asp:GridView ID="EmpGrid" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                    OnSelectedIndexChanged="EmpGrid_SelectedIndexChanged" PageSize="20" AllowPaging="true"
                    OnPageIndexChanging="EmpGrid_PageIndexChanging">

                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Dept_ID" HeaderText="Department&nbsp;ID" Visible="false" ReadOnly="True">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Dept_Name" HeaderText="Department" ReadOnly="True">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="center" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="280px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="EmployeeRequired" HeaderText="Emp. Required" ReadOnly="True">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Name" HeaderText="Department Head" ReadOnly="True">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Active">
                            <ItemTemplate>
                                <asp:Label ID="lblIsActive" runat="server" Text='<%#Eval("IsActive")%>'></asp:Label>
                                <div style="display: none;">
                                    <asp:Label ID="lblrecord" runat="server" Text='<%#Eval("Dept_ID")+"#"+Eval("Dept_Name")+"#"+Eval("IsActive")+"#"+Eval("EmployeeRequired")+"#"+Eval("DeptHeadID")%>'></asp:Label>
                                </div>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>
                        <asp:CommandField ShowSelectButton="True" HeaderText="Edit" ButtonType="Image" SelectImageUrl="~/Images/edit.png">
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                        </asp:CommandField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>
