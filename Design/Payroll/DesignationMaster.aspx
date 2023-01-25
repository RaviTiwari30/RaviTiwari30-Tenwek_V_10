<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="DesignationMaster.aspx.cs" Inherits="Design_Payroll_DesignationMaster" %>

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
            $("#<%=txtDesignation.ClientID %>").focus();
        });
            function displayValidationResult() {
                if (typeof (Page_Validators) == "undefined") return;
                var Department = document.getElementById("<%=reqDesignation.ClientID%>");
                var Grade = document.getElementById("<%=reqGrade.ClientID%>");
                var LblName = document.getElementById("<%=lblmsg.ClientID%>");
                ValidatorValidate(Department);
                if (!Department.isvalid) {
                    LblName.innerText = Department.errormessage;
                    return false;
                }
                ValidatorValidate(Grade);
                if (!Grade.isvalid) {
                    LblName.innerText = Grade.errormessage;
                    return false;
                }
                else {

                }

            }
    </script>
    <script type="text/javascript" >

        function validatespace() {
            var card = $('#<%=txtDesignation.ClientID %>').val();
            if (card.charAt(0) == ' ' || card.charAt(0) == '.') {
                $('#<%=txtDesignation.ClientID %>').val('');
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
                    var card = $('#<%=txtDesignation.ClientID %>').val();
                    if (card.charAt(0) == ' ') {
                        $('#<%=txtDesignation.ClientID %>').val('');
                        $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space');
                        return false;
                    }
                    //List of special characters you want to restrict
                    if (keychar == "'" || keychar == "`" || keychar == "!" || keychar == "." || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "45") || (keynum >= "91" && keynum <= "95") || (keynum >= "49" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
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
            <b>Designation Master<br />
            </b>
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Designation Details
            </div>
            <div class="row">
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Designation
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                        <asp:TextBox ID="txtDesignation" runat="server" CssClass="requiredField" MaxLength="50" ToolTip="Enter Designation"
                            TabIndex="1" AutoCompleteType="Disabled" onkeypress="return check(event)"
                            onkeyup="validatespace();"></asp:TextBox>
                             
                        <asp:TextBox Visible="false" ID="txtLetterNo" runat="server" Width="43px">0</asp:TextBox>
                        <strong></strong>
                        <asp:TextBox ID="txtRef" Visible="false" runat="server" Width="43px">0</asp:TextBox>
                        <strong></strong>
                        <asp:TextBox ID="txtCL" Visible="False" runat="server" Width="43px">0</asp:TextBox>
                        <strong>
                            <asp:TextBox ID="txtEL" Visible="False" runat="server" Width="43px">0</asp:TextBox></strong>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Grade
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlGrade" runat="server" CssClass="requiredField" TabIndex="2" ToolTip="Select Grade">
                        </asp:DropDownList>
                       </div>
                        <div class="col-md-6">
                              <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" TabIndex="3" ToolTip="Click to Save"
                            Text="Save" OnClientClick="return displayValidationResult();" OnClick="btnSave_Click"
                            ValidationGroup="v1" Style="width:100px;" />&nbsp;
                        <asp:Button ID="btnUpdate" runat="server" CssClass="ItDoseButton" TabIndex="4" ToolTip="Click to Update"
                            Text="Update" OnClientClick="return displayValidationResult();" OnClick="btnUpdate_Click"
                            ValidationGroup="v1" Style="width:100px;" />
                        <asp:Button ID="btnCancel" runat="server" CssClass="ItDoseButton" TabIndex="5" ToolTip="Click to Cancel"
                            Text="Cancel" OnClick="btnCancel_Click" Style="width:100px;" />
                        </div>
                        <div style="display:none;">
                             <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="txtRef"
                            Display="None" ErrorMessage="Enter RefNo" SetFocusOnError="True" ValidationGroup="v1"></asp:RequiredFieldValidator>
                        <asp:RequiredFieldValidator ControlToValidate="txtDesignation" SetFocusOnError="true"
                            ID="reqDesignation" runat="server" Display="None" ErrorMessage="Enter Designation Name"
                            ValidationGroup="v1"></asp:RequiredFieldValidator>
                        <asp:RequiredFieldValidator ControlToValidate="txtLetterNo" SetFocusOnError="true"
                            ID="RequiredFieldValidator4" runat="server" Display="None" ErrorMessage="Letter No. Required!"
                            ValidationGroup="v1"></asp:RequiredFieldValidator>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtCL"
                            Display="None" ErrorMessage="CL Required!" SetFocusOnError="true" ValidationGroup="v1"></asp:RequiredFieldValidator>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtEL"
                            Display="None" ErrorMessage="EL Required!" SetFocusOnError="true" ValidationGroup="v1"></asp:RequiredFieldValidator>
                        <asp:RequiredFieldValidator ID="reqGrade" runat="server" ControlToValidate="ddlGrade"
                            Display="None" ErrorMessage="Select Grade" InitialValue="0" SetFocusOnError="true"
                            ValidationGroup="v1"></asp:RequiredFieldValidator>
                             <cc1:FilteredTextBoxExtender TargetControlID="txtEL" FilterMode="ValidChars" ValidChars="."
                            FilterType="Numbers,Custom" ID="FilteredTextBoxExtender1" runat="server">
                        </cc1:FilteredTextBoxExtender>
                        <cc1:FilteredTextBoxExtender TargetControlID="txtCL" FilterMode="ValidChars" ValidChars="."
                            FilterType="Numbers,Custom" ID="FilteredTextBoxExtender2" runat="server">
                        </cc1:FilteredTextBoxExtender>
                        <cc1:FilteredTextBoxExtender TargetControlID="txtLetterNo" FilterMode="ValidChars"
                            ValidChars="." FilterType="Numbers,Custom" ID="FilteredTextBoxExtender3" runat="server">
                        </cc1:FilteredTextBoxExtender>
                        <cc1:FilteredTextBoxExtender TargetControlID="txtRef" FilterType="Numbers" ID="FilteredTextBoxExtender4"
                            runat="server">
                        </cc1:FilteredTextBoxExtender>
                        </div>
                    </div>
                </div>
            </div>
            </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Designation List
            </div>
            <div class="row">
                <div class="col-md-24" align="center">
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
                                <asp:BoundField DataField="Des_ID" HeaderText="Designation&nbsp;ID" Visible="false" ReadOnly="True">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Designation_Name" HeaderText="Designation" ReadOnly="True">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="280px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="LetterNo" Visible="False" HeaderText="Letter No." ReadOnly="True">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="RefNo" Visible="False" HeaderText="Ref.No." ReadOnly="True">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="CL" Visible="False" HeaderText="CL" ReadOnly="True">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="EL" Visible="False" HeaderText="EL" ReadOnly="True">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Grade" HeaderText="Grade" ReadOnly="True">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                                </asp:BoundField>
                                <asp:CommandField ShowSelectButton="True"  HeaderText="Edit"    ButtonType="Image" SelectImageUrl="~/Images/edit.png" >
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                </asp:CommandField>
                                <asp:TemplateField Visible="false">
                                    <ItemTemplate>
                                        <div style="display: none;">
                                            <asp:Label ID="lblrecord" runat="server" Text='<%#Eval("Des_ID")+"#"+Eval("Designation_Name")+"#"+Eval("LetterNo")+"#"+Eval("RefNo")+"#"+Eval("CL")+"#"+Eval("EL")+"#"+Eval("Grade")%>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                </div>

            </div>
        </div>
    </div>
</asp:Content>