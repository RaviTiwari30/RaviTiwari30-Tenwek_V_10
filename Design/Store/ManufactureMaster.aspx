<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="ManufactureMaster.aspx.cs" Inherits="Design_Pharma_ManufactureMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">

        function CancelPopup() {

            $('#<%=txtName1.ClientID%>,#<%=txtDLNo.ClientID%>,#<%=txtTITNO1.ClientID%>,#<%=txtTel1.ClientID%>,#<%=txtMob1.ClientID%>').val('');
            $('#<%=txtPinCode.ClientID%>,#<%=txtCountry.ClientID%>,#<%=txtCity1.ClientID%>,#<%=txtAdd.ClientID%>,#<%=txtAdd2.ClientID%>,#<%=txtAdd3.ClientID%>').val('');
            $('#<%=txtEmail.ClientID%>,#<%=txtContact.ClientID%>,#<%=txtFax1.ClientID%>').val('');
            $('#<%=Label2.ClientID%>,#<%=Label3.ClientID %>').text('');
        }
        function validateDocContact() {
            if ($('#<%=txtName2.ClientID %>').val() == "") {
                $('#<%=Label3.ClientID %>').show();
                $('#<%=Label3.ClientID %>').text('Please Enter Name');
                $('#<%=txtName2.ClientID %>').focus();
                return false;
            }
            else {
                $('#<%=Label3.ClientID %>').hide();
                $('#<%=Label3.ClientID %>').text('');
            }
            if ($('#<%=txtName2.ClientID %>').val().length < "3") {
                $('#<%=Label3.ClientID %>').show();
                $('#<%=Label3.ClientID %>').text('Please Enter Atleast 3 Characters');
                $('#<%=txtName2.ClientID %>').focus();
                return false;
            }
            else {
                $('#<%=Label3.ClientID %>').hide();
                $('#<%=Label3.ClientID %>').text('');
            }

            var emailaddress = $('#<%=txtEmail2.ClientID %>').val();
            var emailexp = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
            if ((emailexp.test(emailaddress) == false) && (emailaddress != "")) {
                $('#<%=Label3.ClientID %>').show();
                $('#<%=Label3.ClientID %>').text('Please Enter Valid Email Address');
                $('#<%=txtEmail2.ClientID %>').val('');
                $('#<%=txtEmail2.ClientID %>').focus();
                return false;
            }
            else {
                $('#<%=Label3.ClientID %>').hide();
                $('#<%=Label3.ClientID %>').text('');
            }

            if ($('#<%=txtMobile.ClientID %>').val() == "") {
                $('#<%=Label3.ClientID %>').show();
                $('#<%=Label3.ClientID %>').text('Please Enter Contact No.');
                $('#<%=txtMobile.ClientID %>').focus();
                return false;
            }
            else {
                $('#<%=Label3.ClientID %>').hide();
                $('#<%=Label3.ClientID %>').text('');
            }

            if ($('#<%=txtMobile.ClientID %>').val().length < "10") {
                $('#<%=Label3.ClientID %>').show();
                $('#<%=Label3.ClientID %>').text('Contact No. Must be 10-15 Digit');
                $('#<%=txtMobile.ClientID %>').focus();
                return false;
            }
            else {
                $('#<%=Label3.ClientID %>').hide();
                $('#<%=Label3.ClientID %>').text('');
            }

        }
        function validateDocContactNew() {

            if ($('#<%=txtName1.ClientID %>').val() == "") {
                $('#<%=Label2.ClientID %>').show();
                $('#<%=Label2.ClientID %>').text('Please Enter Name');
                $('#<%=txtName1.ClientID %>').focus();
                return false;
            }
            else {
                $('#<%=Label2.ClientID %>').hide();
                $('#<%=Label2.ClientID %>').text('');
            }
            if ($('#<%=txtName1.ClientID %>').val().length < "3") {
                $('#<%=Label2.ClientID %>').show();
                $('#<%=Label2.ClientID %>').text('Please Enter Atleast 3 Characters');
                $('#<%=txtName1.ClientID %>').focus();
                return false;
            }
            else {
                $('#<%=Label2.ClientID %>').hide();
                $('#<%=Label2.ClientID %>').text('');
            }
            var emailaddress = $('#<%=txtEmail.ClientID %>').val();
            var emailexp = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
            if ((emailexp.test(emailaddress) == false) && (emailaddress != "")) {
                $('#<%=Label2.ClientID %>').show();
                $('#<%=Label2.ClientID %>').text('Please Enter Valid Email Address');
                $('#<%=txtEmail.ClientID %>').val('');
                $('#<%=txtEmail.ClientID %>').focus();
                return false;
            }
            else {
                $('#<%=Label2.ClientID %>').hide();
                $('#<%=Label2.ClientID %>').text('');
            }

            if ($('#<%=txtMob1.ClientID %>').val() == "") {
                $('#<%=Label2.ClientID %>').show();
                $('#<%=Label2.ClientID %>').text('Please Enter Contact No.');
                $('#<%=txtMob1.ClientID %>').focus();
                return false;
            }
            else {
                $('#<%=Label2.ClientID %>').hide();
                $('#<%=Label2.ClientID %>').text('');
            }

            if ($('#<%=txtMob1.ClientID %>').val().length < "10") {
                $('#<%=Label2.ClientID %>').show();
                $('#<%=Label2.ClientID %>').text('Contact No. Must be 10-15 Digit');
                $('#<%=txtMob1.ClientID %>').focus();
                return false;
            }
            else {
                $('#<%=Label2.ClientID %>').hide();
                $('#<%=Label2.ClientID %>').text('');
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
            var Pname1 = $('#txtContact').val();
            var Pname2 = $('#txtCountry').val();
            var Pname3 = $('#txtCity1').val();
            var Pname4 = $('#txtName1').val();
            var Pname5 = $('#txtName2').val();
            var Pname6 = $('#txtContactPerson2').val();
            var Pname7 = $('#txtCountry2').val();
            var Pname8 = $('#txtCity2').val();
            var Pname9 = $('#txtManuName').val();
            if (Pname1.charAt(0) == ' ') {
                $('#txtContact').val('');
                $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space');
                return false;
            }

            if (Pname2.charAt(0) == ' ') {
                $('#txtCountry').val('');
                $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space');
                return false;
            }
            if (Pname3.charAt(0) == ' ') {
                $('#txtCity1').val('');
                $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space');
                return false;
            }
            if (Pname4.charAt(0) == ' ') {
                $('#txtName1').val('');
                $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space');
                return false;
            }
            if (Pname5.charAt(0) == ' ') {
                $('#txtName2').val('');
                $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space');
                return false;
            }
            if (Pname6.charAt(0) == ' ') {
                $('#txtContactPerson2').val('');
                $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space');
                return false;
            }
            if (Pname7.charAt(0) == ' ') {
                $('#txtCountry2').val('');
                $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space');
                return false;
            }
            if (Pname8.charAt(0) == ' ') {
                $('#txtCity2').val('');
                $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space');
                return false;
            }
            if (Pname9.charAt(0) == ' ') {
                $('#txtManuName').val('');
                $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space');
                return false;
            }

            //List of special characters you want to restrict
            if (keychar == "'" || keychar == "`" || keychar == "!" || keychar == "~" || (keynum >= "91" && keynum <= "95") || (keynum >= "48" && keynum <= "64") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }

            else {
                return true;
            }
        }

        function validatespace() {
            var PCountry = $('#txtCountry').val();
            var PCity = $('#txtCity1').val();
            var Pname1 = $('#txtName1').val();
            var Pname2 = $('#txtName2').val();
            var PCountry2 = $('#txtCountry2').val();
            var PCity2 = $('#txtCity2').val();
            var cp1 = $('#txtContact').val();
            var cp2 = $('#txtContactPerson2').val();
            var companyname = $('#txtManuName').val();
            if (Pname1.charAt(0) == ' ' || Pname1.charAt(0) == '.' || Pname1.charAt(0) == ',' || Pname1.charAt(0) == '&') {
                $('#txtName1').val('');
                $('#<%=Label2.ClientID %>').show();
                $('#<%=Label2.ClientID %>').text('First Character Cannot Be Space/Dot');
                Pname1.replace(Pname1.charAt(0), "");
                return false;
            }
            if (Pname2.charAt(0) == ' ' || Pname2.charAt(0) == '.' || Pname2.charAt(0) == ',' || Pname2.charAt(0) == '&') {
                $('#txtName2').val('');
                $('#<%=Label3.ClientID %>').show();
                $('#<%=Label3.ClientID %>').text('First Character Cannot Be Space/Dot');
                Pname2.replace(Pname2.charAt(0), "");
                return false;
            }

            if (PCountry.charAt(0) == ' ' || PCountry.charAt(0) == '.' || PCountry.charAt(0) == ',') {
                $('#txtCountry').val('');
                $('#<%=Label2.ClientID %>').show();
                $('#<%=Label2.ClientID %>').text('First Character Cannot Be Space/Dot');
                PCountry.replace(PCountry.charAt(0), "");
                return false;
            }
            if (PCity.charAt(0) == ' ' || PCity.charAt(0) == '.' || PCity.charAt(0) == ',') {
                $('#txtCity1').val('');
                $('#<%=Label2.ClientID %>').show();
                $('#<%=Label2.ClientID %>').text('First Character Cannot Be Space/Dot');
                PCity.replace(PCity.charAt(0), "");
                return false;
            }
            if (PCountry2.charAt(0) == ' ' || PCountry2.charAt(0) == '.' || PCountry2.charAt(0) == ',') {
                $('#txtCountry2').val('');
                $('#<%=Label3.ClientID %>').show();
                $('#<%=Label3.ClientID %>').text('First Character Cannot Be Space/Dot');
                PCountry2.replace(PCountry2.charAt(0), "");
                return false;
            }
            if (PCity2.charAt(0) == ' ' || PCity2.charAt(0) == '.' || PCity2.charAt(0) == ',') {
                $('#txtCity2').val('');
                $('#<%=Label3.ClientID %>').show();
                $('#<%=Label3.ClientID %>').text('First Character Cannot Be Space/Dot');
                PCity2.replace(PCity2.charAt(0), "");
                return false;
            }
            if (cp1.charAt(0) == ' ' || cp1.charAt(0) == '.' || cp1.charAt(0) == ',') {
                $('#txtContact').val('');
                $('#<%=Label2.ClientID %>').show();
                $('#<%=Label2.ClientID %>').text('First Character Cannot Be Space/Dot');
                cp1.replace(cp1.charAt(0), "");
                return false;
            }
            if (cp2.charAt(0) == ' ' || cp2.charAt(0) == '.' || cp2.charAt(0) == ',') {
                $('#txtContactPerson2').val('');
                $('#<%=Label3.ClientID %>').show();
                $('#<%=Label3.ClientID %>').text('First Character Cannot Be Space/Dot');
                cp2.replace(cp2.charAt(0), "");
                return false;
            }
            if (companyname.charAt(0) == ' ' || companyname.charAt(0) == '.' || companyname.charAt(0) == ',') {
                $('#txtManuName').val('');
                $('#<%=Label3.ClientID %>').show();
                $('#<%=Label3.ClientID %>').text('First Character Cannot Be Space/Dot');
                companyname.replace(companyname.charAt(0), "");
                return false;
            }
            else {
                $('#<%=Label2.ClientID %>').hide();
                $('#<%=Label3.ClientID %>').hide();
                return true;
            }

        }
        function validateCom() {
            if ($.trim($("#<%=txtManuName.ClientID%>").val()) == "") {
                $("#<%=lblMsg.ClientID%>").text('Please Enter Manufacturer Name');
                $("#<%=txtManuName.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=txtManuName.ClientID%>").val()).length <= 2) {
                $("#<%=lblMsg.ClientID%>").text('Please Enter Atleast 3 Characters');
                $("#<%=txtManuName.ClientID%>").focus();
                return false;
            }
        }
        $(function () {
            $("#btnAddNew").click(function () {
                $find("mdpSave").show();
                $("#txtName1").focus();
            });
        });
    </script>


    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">


            <b>Manufacturer Master</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Manufacturer
            </div>
            <table style="width: 100%">
                <tr>
                    <td style="text-align: right; width: 20%">Manufacturer Name :&nbsp;
                    </td>
                    <td style="text-align: left; width: 30%">
                        <asp:TextBox ID="txtManuName" runat="server" CssClass="requiredField" onkeypress="return check(event)" onkeyup="validatespace();" Width="260px" ClientIDMode="Static">
                        </asp:TextBox>
                        <asp:Label ID="Label5" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>

                    </td>
                    <td style="text-align: left; width: 30%">
                        <table style="width: 100%">
                            <tr>
                                <td>
                                    <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click"
                                        CssClass="ItDoseButton" OnClientClick="return validateCom()" />

                                </td>
                                <td>

                                    <input type="button" class="ItDoseButton" id="btnAddNew" value="Add New" />
                                </td>
                                <td>
                                    <asp:Button ID="btnReport" Text="Report" runat="server" CssClass="ItDoseButton" OnClick="btnReport_Click" />

                                </td>
                            </tr>
                        </table>
                    </td>
                    <td style="width: 10%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </td>
                </tr>
            </table>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Results
            </div>
            <div style="width: 100%;">
                <asp:GridView ID="grdManu" runat="server" AutoGenerateColumns="False" AllowPaging="True"
                    CssClass="GridViewStyle" OnPageIndexChanging="grdManu_PageIndexChanging" OnRowCommand="grdManu_RowCommand"
                    Width="100%">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex + 1%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name" HeaderStyle-Width="150px">
                            <ItemTemplate>
                                <%#Eval("CompanyName")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />

                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Address1" HeaderStyle-Width="100px">
                            <ItemTemplate>
                                <%#Eval("Address1")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Address2" HeaderStyle-Width="80px">
                            <ItemTemplate>
                                <%#Eval("Address2")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Postal Code" HeaderStyle-Width="60px">
                            <ItemTemplate>
                                <%#Eval("PinCode")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="City" HeaderStyle-Width="80px">
                            <ItemTemplate>
                                <%#Eval("City")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Country" HeaderStyle-Width="80px" Visible="false">
                            <ItemTemplate>
                                <%#Eval("Country")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Contact Person" HeaderStyle-Width="100px">
                            <ItemTemplate>
                                <%#Eval("ContactPerson")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />

                        </asp:TemplateField>


                        <asp:TemplateField HeaderText="Telephone" Visible="false">
                            <ItemTemplate>
                                <%#Eval("phone")%>
                            </ItemTemplate>

                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Telephone No." HeaderStyle-Width="80px">
                            <ItemTemplate>
                                <%#Eval("Mobile")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Fax" HeaderStyle-Width="80px">
                            <ItemTemplate>
                                <%#Eval("FAX")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="E-Mail" HeaderStyle-Width="100px">
                            <ItemTemplate>
                                <%#Eval("EMAIL")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status" HeaderStyle-Width="60px">
                            <ItemTemplate>
                                <%#Eval("IsActive")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />

                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="User Name" HeaderStyle-Width="80px">
                            <ItemTemplate>
                                <%#Eval("UserName")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="Is Asset" HeaderStyle-Width="60px">
                            <ItemTemplate>
                                <%#Eval("IsAsset")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />

                        </asp:TemplateField>
                        
                        <%-- <asp:TemplateField Visible="False">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:Label ID="lblManufacture" runat="server" Text='<%#Eval("ManufactureID")+"#"+Eval("Name")+"#"+Eval("IsActive")%>'></asp:Label>
                                </ItemTemplate>
                                </asp:TemplateField>--%>

                        <asp:TemplateField HeaderText="Edit">
                            <ItemTemplate>
                                <asp:Label ID="lblVendorId" Text='<%# Eval("ManufactureID") %>' runat="server" Visible="False"></asp:Label>
                                <asp:ImageButton ID="imbModify" ToolTip="Modify Item" runat="server" ImageUrl="~/Images/edit.png" CausesValidation="false" CommandArgument='<%# Eval("ManufactureID") %>'
                                    CommandName="AEdit" />
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
    <asp:Panel ID="pnlSave" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none; width: 500px">
        <div class="Purchaseheader" id="Div1" runat="server">
            Add New Manufacturer
        </div>
        <div class="content" style="margin-left: 20px">
            <table style="width: 458px; border-collapse: collapse">
                <tr>
                    <td colspan="2" style="text-align: center">
                        <asp:Label ID="Label2" runat="server" Text="" CssClass="ItDoseLblError">
                        </asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 153px; text-align: right;">Name :&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:TextBox ID="txtName1" CssClass="requiredField" runat="server" Font-Bold="true" Width="250px"
                            MaxLength="150" ClientIDMode="Static" onkeypress="return check(event)" onkeyup="validatespace();">
                        </asp:TextBox>
                        <asp:Label ID="Label4" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>

                    </td>
                </tr>
                <tr>
                    <td style="width: 153px; text-align: right;">Code :&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:TextBox ID="txtCode1" runat="server" Font-Bold="true" Width="250px"
                            MaxLength="50" ClientIDMode="Static">
                        </asp:TextBox>


                    </td>
                </tr>

                <tr>
                    <td style="width: 153px; text-align: right;">Address1 :&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:TextBox ID="txtAdd" runat="server" Width="250px"
                            MaxLength="200">
                        </asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 153px; text-align: right;">Address2 :&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:TextBox ID="txtAdd2" runat="server" Width="250px"
                            MaxLength="100">
                        </asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 153px; text-align: right;">Address3 :&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:TextBox ID="txtAdd3" runat="server" Width="250px"
                            MaxLength="100">
                        </asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 153px; text-align: right;">Postal Code :&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:TextBox ID="txtPinCode" runat="server" MaxLength="10" Width="250px">
                        </asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" TargetControlID="txtPinCode"
                            FilterType="Custom, Numbers" ValidChars="0123456789" Enabled="True">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                </tr>
                <tr>
                    <td style="width: 153px; text-align: right;">City :&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:TextBox ID="txtCity1" runat="server" Width="250px"
                            MaxLength="100" ClientIDMode="Static" onkeypress="return check(event)" onkeyup="validatespace();">
                        </asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 153px; text-align: right;">Country :&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:TextBox ID="txtCountry" runat="server" Width="250px"
                            MaxLength="100" ClientIDMode="Static" onkeypress="return check(event)" onkeyup="validatespace();">
                        </asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 183px; text-align: right;">Contact Person :&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:TextBox ID="txtContact" runat="server" ClientIDMode="Static"
                            Width="250px" MaxLength="100" onkeypress="return check(event)" onkeyup="validatespace();">
                        </asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 153px; text-align: right;">Telephone No. :&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:TextBox ID="txtMob1" runat="server" CssClass="" MaxLength="15" Width="250px">
                        </asp:TextBox>&nbsp;<asp:Label ID="LabelUp" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        <%--<cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" TargetControlID="txtMob1"
                            FilterType="Custom, Numbers" ValidChars="0123456789" Enabled="True">
                        </cc1:FilteredTextBoxExtender>--%>
                    </td>
                </tr>
                <tr>
                    <td style="width: 153px; text-align: right;">Fax :&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:TextBox ID="txtFax1" runat="server" Width="250px"
                            MaxLength="50">
                        </asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtFax1"
                            FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                </tr>
                <tr>
                    <td style="width: 153px; text-align: right;">E-Mail :&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:TextBox ID="txtEmail" runat="server" MaxLength="100"
                            Width="250px">
                        </asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 153px; text-align: right;">GSTIN No :&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:TextBox ID="txtGSTINNo" runat="server" MaxLength="100"
                            Width="250px">
                        </asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 153px; text-align: right;">Is Asset :&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:CheckBox ID="chkIsAsset" runat="server" />
                    </td>
                </tr>
                <tr style="display: none">
                    <td style="width: 153px; text-align: right;">TIN No. :&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:TextBox ID="txtTITNO1" runat="server" Width="250px"
                            MaxLength="50">
                        </asp:TextBox>
                    </td>
                </tr>
                <tr style="display: none">
                    <td style="width: 153px; text-align: right;">DL No. :&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:TextBox ID="txtDLNo" runat="server" MaxLength="50"
                            Width="250px">
                        </asp:TextBox>
                    </td>
                </tr>







                <tr style="display: none;">
                    <td style="width: 153px; text-align: right;">Telephone :&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:TextBox ID="txtTel1" runat="server" MaxLength="200">
                        </asp:TextBox>
                    </td>
                </tr>
            </table>
        </div>
        <br />

        <div class="filterOpDiv" style="text-align: center">
            <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="ItDoseButton"
                ValidationGroup="Save" OnClick="btnSave_Click" OnClientClick="return validateDocContactNew();" />
            <asp:Button ID="btnCancel" runat="server" Text="Cancel" CausesValidation="false"
                CssClass="ItDoseButton" />
        </div>

    </asp:Panel>
    <cc1:ModalPopupExtender ID="mdpSave" BehaviorID="mdpSave" runat="server" CancelControlID="btnCancel" DropShadow="true"
        TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground" PopupControlID="pnlSave"
        PopupDragHandleControlID="Div1">
    </cc1:ModalPopupExtender>
    <asp:Button ID="btnHidden" runat="server" Text="Button" Style="display: none;"></asp:Button>
    <asp:Panel ID="pnlUpdate" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none; width: 500px">
        <div class="Purchaseheader" id="dragUpdate" runat="server">
            Update Manufacturer
        </div>
        <div class="content" style="margin-left: 20px">
            <table style="width: 458px; border-collapse: collapse">
                <tr>
                    <td colspan="2" style="text-align: center">
                        <asp:Label ID="Label3" runat="server" Text="" CssClass="ItDoseLblError">
                        </asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 135px; text-align: right">Name :&nbsp;
                    </td>
                    <td style="width: 395px; text-align: left">
                        <asp:TextBox ID="txtName2" CssClass="requiredField" runat="server" ClientIDMode="Static"
                            onkeyup="validatespace();" Font-Bold="true" Width="250px"
                            MaxLength="150">
                        </asp:TextBox>&nbsp;<span style="color: Red; font-size: 10px;"></span>
                        <cc1:FilteredTextBoxExtender ID="FteName2" runat="server" TargetControlID="txtName2"
                            FilterType="LowercaseLetters,UppercaseLetters,Custom" ValidChars="& " Enabled="True">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                </tr>
                <tr>
                    <td style="width: 153px; text-align: right;">Code :&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:TextBox ID="txtCode2" runat="server" Font-Bold="true" Width="250px"
                            MaxLength="50" ClientIDMode="Static">
                        </asp:TextBox>


                    </td>
                </tr>
                <tr>
                    <td style="width: 135px; text-align: right">Address1 :&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:TextBox ID="txtAddress1" runat="server" Width="250px"
                            MaxLength="200">
                        </asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 135px; text-align: right">Address2 :&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:TextBox ID="txtAddress2" runat="server" Width="250px"
                            MaxLength="100">
                        </asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 135px; text-align: right">Address3 :&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:TextBox ID="txtAddress3" runat="server" Width="250px"
                            MaxLength="100">
                        </asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 135px; text-align: right">Postal Code :&nbsp;
                    </td>
                    <td style="width: 395px; text-align: left">
                        <asp:TextBox ID="txtPinCode2" runat="server" MaxLength="10" Width="250px">
                        </asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender8" runat="server" TargetControlID="txtPinCode2"
                            FilterType="Custom, Numbers" ValidChars="0123456789" Enabled="True">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                </tr>
                <tr>
                    <td style="width: 135px; text-align: right">City :&nbsp;
                    </td>
                    <td style="width: 395px; text-align: left">
                        <asp:TextBox ID="txtCity2" runat="server" ClientIDMode="Static" onkeypress="return check(event)"
                            onkeyup="validatespace();" Width="250px" MaxLength="100">
                        </asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 135px; text-align: right">Country :&nbsp;
                    </td>
                    <td style="width: 395px; text-align: left">
                        <asp:TextBox ID="txtCountry2" ClientIDMode="Static" onkeypress="return check(event)"
                            onkeyup="validatespace();" runat="server" MaxLength="100"
                            Width="250px">
                        </asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 135px; text-align: right">Contact&nbsp;Person&nbsp;:&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:TextBox ID="txtContactPerson2" ClientIDMode="Static" onkeypress="return check(event)"
                            onkeyup="validatespace();" runat="server" MaxLength="100"
                            Width="250px">
                        </asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 135px; text-align: right">Telephone No. :&nbsp;
                    </td>
                    <td style="width: 395px; text-align: left">
                        <asp:TextBox ID="txtMobile" runat="server" MaxLength="12" CssClass="requiredField" Width="250px">
                        </asp:TextBox>&nbsp;<asp:Label ID="LblcNo" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtenderContact" runat="server" TargetControlID="txtMobile"
                            FilterType="Custom, Numbers" ValidChars="0123456789" Enabled="True">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                </tr>
                <tr>
                    <td style="width: 135px; text-align: right">Fax :&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:TextBox ID="txtfax2" runat="server" MaxLength="50"
                            Width="250px">
                        </asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender9" runat="server" TargetControlID="txtfax2"
                            FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                </tr>

                <tr>
                    <td style="width: 135px; text-align: right">E-Mail :&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:TextBox ID="txtEmail2" runat="server" MaxLength="50"
                            Width="250px">
                        </asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 135px; text-align: right">GSTIN No :&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:TextBox ID="txtGSTINUpdate" runat="server" MaxLength="20"
                            Width="250px">
                        </asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 153px; text-align: right;">Is Asset :&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:CheckBox ID="chkIsAssetUpdate" runat="server" />
                    </td>
                </tr>
                <tr style="display: none">
                    <td style="width: 135px; text-align: right">TIN No. :&nbsp;
                    </td>
                    <td style="width: 395px; text-align: left">
                        <asp:TextBox ID="txtTITNO2" runat="server" Font-Bold="true"
                            Width="250px" MaxLength="50">
                        </asp:TextBox>
                    </td>
                </tr>
                <tr style="display: none">
                    <td style="width: 135px; text-align: right">DL No. :&nbsp;
                    </td>
                    <td style="width: 395px; text-align: left">
                        <asp:TextBox ID="txtDLNo2" runat="server" Font-Bold="true"
                            MaxLength="50" Width="250px">
                        </asp:TextBox>
                    </td>
                </tr>






                <tr style="display: none;">
                    <td style="width: 135px; text-align: right">Telephone :&nbsp;
                    </td>
                    <td style="width: 395px">

                        <asp:TextBox ID="txtPhone" runat="server" MaxLength="12"
                            Style="display: none">
                        </asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender7" runat="server" TargetControlID="txtPhone"
                            FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                </tr>
                <tr>
                    <td style="width: 135px; text-align: right">Status :&nbsp;
                    </td>
                    <td style="width: 395px">
                        <asp:RadioButtonList ID="rbtnActive" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Value="1">Active</asp:ListItem>
                            <asp:ListItem Value="0">InActive</asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
            </table>
        </div>
        <br />
        <div class="filterOpDiv" style="text-align: center">

            <asp:Button ID="btnupdate" runat="server" Text="Update" CssClass="ItDoseButton"
                ValidationGroup="Update" OnClick="btnupdate_Click" OnClientClick="return validateDocContact();" />
            <asp:Button ID="btnItemCancel" runat="server" Text="Cancel" CausesValidation="false"
                CssClass="ItDoseButton" />&nbsp;
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpeCreateGroup" runat="server" CancelControlID="btnItemCancel"
        DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlUpdate" PopupDragHandleControlID="dragUpdate">
    </cc1:ModalPopupExtender>
</asp:Content>
