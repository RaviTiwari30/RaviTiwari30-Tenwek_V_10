<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="PayrollBankMaster.aspx.cs" Inherits="Design_Payroll_PayrollBankMaster" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>
<asp:content id="Content1" contentplaceholderid="ContentPlaceHolder1" runat="Server">
    
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript" >
        function blanktext() {
            $("#<%=txtNewBankName.ClientID %>").val('');
            $("#<%=txtNewBankCode.ClientID %>").val('');
            $("#<%=lblmsgpopup.ClientID %>").text('');
        }
        function blanklevel() {
            $("#<%=lblmsg.ClientID%>").text('');

        }
        function ValidateBranch() {
            if (typeof (Page_Validators) == "undefined") return;
            var BankName = document.getElementById("<%=reqBankName.ClientID%>");
            var BranchName = document.getElementById("<%=reqBranchName.ClientID%>");
            var BranchCode = document.getElementById("<%=reqBranchCode.ClientID%>");
            var LblName = document.getElementById("<%=lblmsg.ClientID%>");
            ValidatorValidate(BankName);
            if (!BankName.isvalid) {
                LblName.innerText = BankName.errormessage;
                return false;
            }
            ValidatorValidate(BranchName);
            if (!BranchName.isvalid) {
                LblName.innerText = BranchName.errormessage;
                return false;
            }
            ValidatorValidate(BranchCode);
            if (!BranchCode.isvalid) {
                LblName.innerText = BranchCode.errormessage;
                return false;
            }
        }
        function validatebank() {
            try {
                if (typeof (Page_Validators) == "undefined") return;
                var NewBankName = document.getElementById("<%=reqNewBankName.ClientID%>");
                var NewBankCode = document.getElementById("<%=reqNewBankCode.ClientID%>");
                var LblName = document.getElementById("<%=lblmsgpopup.ClientID%>");
                ValidatorValidate(NewBankName);
                if (!NewBankName.isvalid) {
                    LblName.innerText = NewBankName.errormessage;
                    return false;
                }
                ValidatorValidate(NewBankCode);
                if (!NewBankCode.isvalid) {
                    LblName.innerText = NewBankCode.errormessage;
                    return false;
                }
            }
            catch (e) {

            }

        }
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find("mpBank")) {
                    $find("mpBank").hide();
                    $("#<%=txtNewBankName.ClientID %>").val('');
                    $("#<%=txtNewBankCode.ClientID %>").val('');
                    $("#<%=lblmsgpopup.ClientID %>").text('');
                }
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
            var card = $('#<%=txtBranchCode.ClientID %>').val();
            if (card.charAt(0) == ' ') {
                $('#<%=txtBranchCode.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space');
                return false;
            }
            var card = $('#<%=txtBranchName.ClientID %>').val();
            if (card.charAt(0) == ' ') {
                $('#<%=txtBranchName.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space');
                return false;
            }
            //List of special characters you want to restrict
            if (keychar == "'" || keychar == "`" || keychar == "!" || keychar == "~" || keychar == "." || keychar == ";" || (keynum >= "40" && keynum <= "45") || (keynum >= "91" && keynum <= "95") || (keynum >= "58" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }

            else {
                return true;
            }
        }
        function closeBank() {
            if ($find("mpBank")) {
                $find("mpBank").hide();
                $("#<%=txtNewBankName.ClientID %>").val('');
                $("#<%=txtNewBankCode.ClientID %>").val('');
                $("#<%=lblmsgpopup.ClientID %>").text('');
            }
        }
    </script>
    <div id="Pbody_box_inventory">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Payroll Bank Master </b>
            <br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Bank Details 
            </div>
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                            Bank Name
                                </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:DropDownList ID="ddlBankName" runat="server" ToolTip="Select Bank Name" CssClass="requiredField">
                        </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="reqBankName" runat="server" ControlToValidate="ddlBankName"
                            ErrorMessage="Please Select Bank Name" Display="None" ValidationGroup="btnsave"
                            InitialValue="0"></asp:RequiredFieldValidator>
                        </div>
                        <div class="col-md-1">
                            <input type="button" id="btnNewBank" class="ItDoseButton" value="New" ToolTip="Click To Add New Bank" />
                            
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">
                            Branch Name
                                </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtBranchName" runat="server" MaxLength="50" TabIndex="3" ToolTip="Enter Branch Name" CssClass="requiredField" onkeypress="return check(event)"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="reqBranchName" runat="server" ControlToValidate="txtBranchName"
                            ErrorMessage="Please Enter Branch Name" Display="None" ValidationGroup="btnsave"></asp:RequiredFieldValidator>  
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            Branch Code
                                </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtBranchCode" runat="server" MaxLength="30" TabIndex="1" ToolTip="Enter  Branch Code" CssClass="requiredField" onkeypress="return check(event)"></asp:TextBox>
                             <asp:RequiredFieldValidator ID="reqBranchCode" runat="server" ControlToValidate="txtBranchCode"
                            ErrorMessage=" Please Enter Branch Code" Display="None" ValidationGroup="btnsave"></asp:RequiredFieldValidator>
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
                             <asp:RadioButtonList ID="rblActive" runat="server" RepeatDirection="Horizontal" TabIndex="2">
                            <asp:ListItem Selected="True" Value="1">Yes</asp:ListItem>
                            <asp:ListItem Value="0">No</asp:ListItem>
                        </asp:RadioButtonList>
                            </div>
                         </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" 
                TabIndex="8" CssClass="ItDoseButton" OnClientClick="return ValidateBranch();"
                ValidationGroup="btnsave" ToolTip="Click to Save" style="margin-top:7px; width:100px;" />
            <asp:Button ID="btnUpdate" runat="server" OnClick="btnUpdate_Click" Text="Update"
                CssClass="ItDoseButton" ValidationGroup="btnsave" OnClientClick="return ValidateBranch();"
                ToolTip="Click to Update" style="margin-top:7px; width:100px;" />
            <asp:Button ID="btnCancel" runat="server" OnClick="btncancel_Click" CssClass="ItDoseButton"
                Text="Cancel"  ToolTip="Click to Cancel" style="margin-top:7px; width:100px;" />
        </div>
        <div class="POuter_Box_Inventory">
             <div class="Purchaseheader">
                Bank List 
            </div>
            <div class="row">
                <div class="col-md-22">
<asp:GridView ID="grdBank" runat="server" AutoGenerateColumns="False" AllowPaging="true"
                PageSize="10" CssClass="GridViewStyle" OnSelectedIndexChanged="grdBank_SelectedIndexChanged"
                OnPageIndexChanging="grdBank_PageIndexChanging">
                
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>
                    <asp:TemplateField HeaderText="S.No.">
                        <ItemTemplate>
                            <%# Container.DataItemIndex+1 %>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle"  HorizontalAlign="Center"/>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="Id" Visible="false">
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="BankName" HeaderText="Bank Name">
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center"/>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="280px" HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="BankCode" HeaderText="Bank Code">
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center"/>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="160px" HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="BranchName" HeaderText="Branch Name">
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center"/>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="260px" HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="BranchCode" HeaderText="Branch Code">
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center"/>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="160px" HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="IsActive" Visible="false">
                        <ItemTemplate>
                            <div style="display: none;">
                                <asp:Label ID="lblrecord" runat="server" Text='<%#Eval("Branch_ID")+"#"+Eval("bankName")+"#"+Eval("BankCode")+"#"+Eval("BranchName")+"#"+Eval("BranchCode")+"#"+Eval("IsActive")%>'></asp:Label>
                            </div>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                    </asp:TemplateField>
                    <asp:CommandField ShowSelectButton="True" ButtonType="Image" SelectImageUrl="~/Images/edit.png"  HeaderText="Edit">
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Center" />
                    </asp:CommandField>
                </Columns>
            </asp:GridView>
                </div>
            </div>
         </div>
        </div>
        <div id="divAddBank"   class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color:white;width:600px; height:140px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divAddBank" aria-hidden="true" onclick="closeEditGRN()">&times;</button>
                    <h4 class="modal-title">Create New Bank</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-24" align="center">
                            <asp:Label ID="lblmsgpopup" runat="server" CssClass="ItDoseLblError"></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-5">
                            <label class="pull-left">Bank Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                            <asp:TextBox ID="txtNewBankName" runat="server" CssClass="requiredField" MaxLength="70" onkeypress="return check(event)"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="reqNewBankName" runat="server" ValidationGroup="SaveBank"
                                ErrorMessage="Please Enter Bank Name" Display="None" SetFocusOnError="true" ControlToValidate="txtNewBankName"></asp:RequiredFieldValidator>
                       
                        </div>
                        <div class="col-md-5">
                            <label class="pull-left">Bank Code</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                            <asp:TextBox ID="txtNewBankCode" runat="server" CssClass="requiredField"  MaxLength="30" onkeypress="return check(event)"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="reqNewBankCode" runat="server" ValidationGroup="SaveBank"
                                ErrorMessage="Please Enter Bank Code" Display="None" SetFocusOnError="true" ControlToValidate="txtNewBankCode"></asp:RequiredFieldValidator>
                         </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnSaveBank" runat="server" Text="Save" ValidationGroup="SaveBank"
                                OnClick="btnSaveBank_Click" CssClass="ItDoseButton" OnClientClick="return validatebank();" />
                    &nbsp;<input type="button" value="Cancel" class="ItDoseButton close" data-dismiss="divAddBank" />
                            
                    </div>
                </div>
            </div>
        </div>

    <script>
        $(document).ready(function () {
            $('#btnNewBank').click(function () {
                $('#divAddBank').showModel();
            });


        });
    </script>
</asp:content>
