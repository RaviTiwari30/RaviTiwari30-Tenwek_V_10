<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="salt_item_master.aspx.cs" Inherits="Design_Store_salt_item_master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        function checkForSecondDecimal(sender, e) {
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));
                if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }
            return true;
        }

        function validatedot() {
            if (($("#<%=txtstrength.ClientID%>").val().charAt(0) == ".")) {
                $("#<%=txtstrength.ClientID%>").val('');
                return false;
            }
            return true;
        }
        function validatespace() {
            var txt_lab = $('#<%=txt_lab.ClientID %>').val();
            var txtGenericEdit = $('#<%=txtGenericEdit.ClientID %>').val();

            if (txt_lab.charAt(0) == ' ' || txt_lab.charAt(0) == '.' || txt_lab.charAt(0) == ',' || txt_lab.charAt(0) == '-') {
                $('#<%=txt_lab.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                txt_lab.replace(txt_lab.charAt(0), "");
                return false;
            }
            if (txtGenericEdit.charAt(0) == ' ' || txtGenericEdit.charAt(0) == '.' || txtGenericEdit.charAt(0) == ',' | txtGenericEdit.charAt(0) == '-') {
                $('#<%=txtGenericEdit.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                txtGenericEdit.replace(txtGenericEdit.charAt(0), "");
                return false;
            }
            else {

                return true;
            }

        }
        function check(sender, e) {
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
            var txt_lab = $('#<%=txt_lab.ClientID %>').val();
            var txtGenericEdit = $('#<%=txtGenericEdit.ClientID %>').val();

            if (txt_lab.charAt(0) == ' ') {
                $('#<%=txt_lab.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space');
                return false;
            }
            if (txtGenericEdit.charAt(0) == ' ') {
                $('#<%=txtGenericEdit.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space');
                return false;
            }
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));

                if ((charCode == 45)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '-');
                        if (hasDec)
                            return false;
                    }
                }
            }
            //List of special characters you want to restrict
            if (keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "44") || (keynum >= "91" && keynum <= "95") || (keynum >= "49" && keynum <= "64") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }
            else {
                return true;
            }
        }
    </script>
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="" style="text-align: center;">
                <b>Generic Master Entry</b><br />
                <asp:Label ID="lblmsg" runat="server" Text="" CssClass="ItDoseLblError"></asp:Label>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div id="Div2" class="Purchaseheader" runat="server">
                Add New Generic
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                New Generic
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txt_lab" runat="server" CssClass="ItDoseTextinputText" onkeypress="return check(this,event)"
                                onkeyup="validatespace();" Width="">
                            </asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <asp:Button ID="btnAddSalt" runat="server" Text="Add New Generic" CssClass="ItDoseButton"
                                OnClick="btnAddSalt_Click" />
                        </div>
                        <div class="col-md-3">
                            <asp:Button ID="Button1" runat="server" Text="Edit" CssClass="ItDoseButton"
                                Width="50px" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div id="Div4" class="Purchaseheader" runat="server">
                Generic Item Details
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Item Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddl_item" runat="server" OnSelectedIndexChanged="bindpage"
                                Width="" AutoPostBack="true">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Selected Item 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lbl_item" runat="server" ForeColor="Red"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Generic List 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddl_salt" runat="server" Style="">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Strength
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtstrength" runat="server" CssClass="ItDoseTextinputText requiredField" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();"
                                MaxLength="8"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Unit
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList CssClass="" ID="ddlUnit" runat="server" Style=""></asp:DropDownList>
                            <cc1:FilteredTextBoxExtender ID="ftestrength" runat="server" TargetControlID="txtstrength"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <div class="" style="margin-top:5px;">
                <asp:GridView ID="grdLedgerName" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                    OnPageIndexChanging="grdLedgerName_PageIndexChanging" Width="100%" OnRowDeleting="del" AllowPaging="True">
                    <Columns>
                        <asp:TemplateField HeaderText="S.No">
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField Visible="False">
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                            <ItemTemplate>
                                <asp:Label ID="lblLedgerNo" runat="server" Text='<%#Bind("ItemID")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="saltname" HeaderText="Generic Name">
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="300px" />
                            <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Left" />
                        </asp:BoundField>

                        <asp:BoundField DataField="Strength" HeaderText="Strength">
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="250px" />
                            <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Left" />
                        </asp:BoundField>
                        <asp:BoundField DataField="strengthUnit" HeaderText="Unit">
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Left" />
                        </asp:BoundField>
                        <asp:TemplateField>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <asp:Label ID="lblVendorId" Text='<%# Bind("ID") %>' runat="server" Visible="False"></asp:Label>

                                <asp:ImageButton ID="img1" ToolTip="remove Item" runat="server" ImageUrl="~/Images/Delete.gif" CausesValidation="false" CommandName="delete" />

                            </ItemTemplate>


                        </asp:TemplateField>

                    </Columns>
                </asp:GridView>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnsave" runat="server" Text="save" CssClass="ItDoseButton" OnClick="btnsave_Click" />
            <asp:Button ID="btnReport" runat="server" Text="Report" CssClass="ItDoseButton" />
        </div>
    </div>
    <asp:Panel ID="pnlEdit" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none;">
        <div class="Purchaseheader" id="Div1" runat="server">
            Edit Generic Name
        </div>
        <div style="text-align: center;">
            <asp:Label ID="lblerrormsg" runat="server" Text="" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="content">
            <br />

            <Ajax:UpdatePanel ID="upd1" runat="server">
                <ContentTemplate>
                    <table>
                        <tr>
                            <td style="width: 10%; text-align: right;">
                                <label class="labelForPO" style="width: 119px; text-align: right">
                                    Select Generic :</label>
                            </td>
                            <td style="width: 10%; text-align: left">
                                <asp:DropDownList ID="ddlGenericForEdit" runat="server" Width="300px" AutoPostBack="true"
                                    OnSelectedIndexChanged="ddlGenericForEdit_SelectedIndexChanged" Style="text-align: left">
                                </asp:DropDownList>

                            </td>
                        </tr>
                        <tr>
                            <td style="width: 30%; text-align: right;">
                                <label class="labelForPO" style="width: 119px; text-align: right;">
                                    Edit :</label>
                            </td>
                            <td style="width: 60%; text-align: left">
                                <asp:TextBox ID="txtGenericEdit" runat="server" Width="300px" onkeypress="return check(this,event)" Style="text-align: left"
                                    onkeyup="validatespace();">
                                </asp:TextBox>
                            </td>

                        </tr>
                        <tr>
                            <td colspan="2" style="width: 60%; text-align: left">
                                <label class="labelForPO" style="width: 119px">
                                </label>
                                <asp:RadioButtonList ID="rdbActive" runat="server" RepeatDirection="Horizontal">
                                    <asp:ListItem Text="Active" Selected="True" Value="1">
                                    </asp:ListItem>
                                    <asp:ListItem Text="InActive" Value="0">
                                    </asp:ListItem>
                                </asp:RadioButtonList>
                            </td>

                        </tr>
                    </table>
                </ContentTemplate>

            </Ajax:UpdatePanel>

            <label class="labelForPO" style="width: 119px">
            </label>
            <div style="width: 60%; text-align: left">
                <asp:Button ID="btnSaveEdit" runat="server" Text="save" CssClass="ItDoseButton" OnClick="btnSaveEdit_Click" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="ItDoseButton" />
            </div>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpEditGeneric" runat="server" CancelControlID="btnCancel"
        DropShadow="true" TargetControlID="Button1" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlEdit" PopupDragHandleControlID="Div1">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlAddGroup" runat="server" CssClass="pnlItemsFilter" Style="display: none;">
        <div class="Purchaseheader" id="dragHandle" runat="server">
            Select Report Type
        </div>
        <div class="content">
            <asp:Panel ID="PnlAddItem" runat="server">
                <asp:RadioButtonList ID="rdoReportFormat" runat="server" RepeatDirection="Horizontal"
                    CssClass="ItDoseRadiobuttonlist">
                    <asp:ListItem Selected="True" Text="PDF" Value="1" />
                    <asp:ListItem Text="Excel" Value="2" />
                </asp:RadioButtonList>
            </asp:Panel>
        </div>
        <div class="filterOpDiv">
            <asp:Button ID="btnReportPopup" runat="server" CssClass="ItDoseButton" Text="Report"
                OnClick="btnReportPopup_Click" />&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnItemCancel" runat="server" CssClass="ItDoseButton" Text="Cancel" />
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpeCreateGroup" runat="server" CancelControlID="btnItemCancel"
        DropShadow="true" TargetControlID="btnReport" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlAddGroup" PopupDragHandleControlID="dragHandle">
    </cc1:ModalPopupExtender>
</asp:Content>
