<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="PublicHolidays.aspx.cs" Inherits="Design_Payroll_PublicHolidays" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        function displayValidationResult() {
            if (typeof (Page_Validators) == "undefined") return;
            var Name = document.getElementById("<%=reqName.ClientID%>");
            var Date = document.getElementById("<%=reqdate.ClientID%>");
            var LblName = document.getElementById("<%=lblMsg.ClientID%>");
            ValidatorValidate(Name);
            if (!Name.isvalid) {
                LblName.innerText = Name.errormessage;
                return false;
            }
            ValidatorValidate(Date);
            if (!Date.isvalid) {
                LblName.innerText = Date.errormessage;
                return false;
            }

        }
    </script>
    <script type="text/javascript">

        function validatespace() {
            var card = $('#<%=txtName.ClientID %>').val();
            if (card.charAt(0) == ' ' || card.charAt(0) == '.') {
                $('#<%=txtName.ClientID %>').val('');
                $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                card.replace(card.charAt(0), "");
                return false;
            }
            else {
                $('#<%=lblMsg.ClientID %>').text('');
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
            var card = $('#<%=txtName.ClientID %>').val();
                if (card.charAt(0) == ' ') {
                    $('#<%=txtName.ClientID %>').val('');
                    $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space');
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
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sm" runat="server" />
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Public Holiday </b>
            <br />
            <asp:Label ID="lblMsg" CssClass="ItDoseLblError" runat="server"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Holiday Details
            </div>
         
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Holiday Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtName" runat="server" CssClass="requiredField" MaxLength="50" TabIndex="1"
                                ToolTip="Enter Holiday Name" AutoCompleteType="Disabled" onkeypress="return check(event)"
                                onkeyup="validatespace();"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="reqName" runat="server" ControlToValidate="txtName"
                                Display="None" ErrorMessage="Please Enter Holiday Name" ValidationGroup="a" SetFocusOnError="True"></asp:RequiredFieldValidator>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                               Holiday Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDate" AutoCompleteType="Disabled" runat="server" CssClass="requiredField" ToolTip="Select Date" TabIndex="2"></asp:TextBox>
                            <cc1:CalendarExtender ID="calucDate" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                            <asp:RequiredFieldValidator ID="reqdate" runat="server" ControlToValidate="txtName"
                                Display="None" ValidationGroup="a" ErrorMessage="Enter Holiday Date" SetFocusOnError="True"></asp:RequiredFieldValidator>
                        </div>
                        

                        <div class="col-md-3">
                            <label class="pull-left">
                                Holiday Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdbHolidayType" runat="server" TabIndex="3"
                                RepeatDirection="Horizontal">
                                <asp:ListItem Selected="True" Value="0">National</asp:ListItem>
                                <asp:ListItem Value="1">Optional</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Is Active
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rbtnActive" runat="server" TabIndex="3"
                                RepeatDirection="Horizontal">
                                <asp:ListItem Selected="True" Value="1">Active</asp:ListItem>
                                <asp:ListItem Value="0">Deactive</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnUpdate" runat="server" Text="Update" CssClass="ItDoseButton" Visible="false"
                OnClick="btnUpdate_Click1" ValidationGroup="a" TabIndex="4" ToolTip="Click to Update" OnClientClick="return displayValidationResult();" Style="margin-top: 7px; width: 100px;" />
            <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSaveRecord_Click"
                CssClass="ItDoseButton" ValidationGroup="a" TabIndex="4" ToolTip="Click to Save" OnClientClick="return displayValidationResult();" Style="margin-top: 7px; width: 100px;" />
            <asp:Button ID="btnCancel" runat="server" Text="Cancel" Visible="False" CssClass="ItDoseButton"
                OnClick="btnCancel_Click" ToolTip="Click to Cancel" TabIndex="5" Style="margin-top: 7px; width: 100px;" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Holiday List
            </div>
            <div class="row" >
                <div class="col-md-22" align="center">
            <asp:GridView ID="grdLeave" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                OnSelectedIndexChanged="grdLeave_SelectedIndexChanged">
                <Columns>
                    <asp:TemplateField HeaderText="S.No.">
                        <ItemStyle CssClass="GridViewLabItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        <ItemTemplate>
                            <%#Container.DataItemIndex+1 %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Id" Visible="false">
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Name" HeaderText="Holiday Name" ItemStyle-CssClass="GridViewLabItemStyle"
                        HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="200px" />
                    <asp:BoundField DataField="Date" HeaderText="Date" ItemStyle-CssClass="GridViewLabItemStyle"
                        HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="120px" />
                    <asp:BoundField DataField="IsActive" HeaderText="Active" ItemStyle-CssClass="GridViewLabItemStyle"
                        HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="80px" />
                    <asp:BoundField DataField="HolidayType" HeaderText="Holiday Type" ItemStyle-CssClass="GridViewLabItemStyle"
                        HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="120px" />
                    
                    <asp:TemplateField HeaderText="Active" Visible="false">
                        <ItemTemplate>
                            <div style="display: none;">
                                <asp:Label ID="lblrecord" runat="server" Text='<%# Eval("ID")+"#"+Eval("Name")+"#"+Eval("Date")+"#"+Eval("IsActive")+"#"+Eval("IsOptionalHoliday")%>'></asp:Label>
                            </div>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                    </asp:TemplateField>
                    <%--<asp:TemplateField HeaderText="Select">
                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        <ItemTemplate>
                            <asp:ImageButton ID="imbSelect" ToolTip="Click to Select" runat="server" ImageUrl="~/Images/Post.gif"
                                CausesValidation="false" CommandArgument='<%#Container.DataItemIndex %>' CommandName="HSelect" />
                        </ItemTemplate>
                    </asp:TemplateField>--%>
                    <asp:CommandField ButtonType="Image" ShowSelectButton="true" HeaderText="Edit" SelectImageUrl="~/Images/edit.png">
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        <ItemStyle CssClass="GridViewLabItemStyle" />
                    </asp:CommandField>
                </Columns>
            </asp:GridView>
                    </div>
                </div>

        </div>
    </div>
</asp:Content>
