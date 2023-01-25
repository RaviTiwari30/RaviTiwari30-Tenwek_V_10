<%@ Page Language="C#" ViewStateMode="Enabled" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="MasterCenter.aspx.cs" Inherits="Design_Centre_MasterCenter" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link rel="stylesheet" href="../../Styles/jquery-ui.css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />

    <script type="text/javascript">
        function showItinialChar() {
            if ($("#chkSelf").prop("checked")) {
                $("#txtInitialChar").show();
                $("#ddlFollowedCentre").hide();
                $("#lblInitialCharCap").text('Prefix');
            }
            else {
                $("#txtInitialChar").hide();
                $("#ddlFollowedCentre").show();
                $("#lblInitialCharCap").text('Centre');
            }
        }

        function email() {
            var emailaddress = $('#<%=txtMail.ClientID %>').val();
            var emailexp = /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/;
            if ((emailexp.test(emailaddress) == false) && (emailaddress != "")) {

                alert('Please enter valid email address.');
                $('#<%=txtMail.ClientID %>').val('');
                $('#<%=txtMail.ClientID %>').focus();
                return false;
            }
            else {
                return true;
            }
        }
        function SelectAllCheckboxes1(chkall) {
            $('#<%=grdOption.ClientID%>').find("input:checkbox").each(function () {
                if (this != chkall) { this.checked = chkall.checked; }
            });
        }


        var Mappaneldoctor = function ()
        {
            var centerid=$('#lblselectedcenterid').text();
            window.open('../EDP/CentreWiseMapping.aspx?CID='+centerid+'');
        }



        function validateCenterName() {
            if ($.trim($("#txtCName").val()) == "") {
                $("#lblMsg").text('Please Enter Centre Name');
                $("#txtCName").focus();
                return false;
            }
            if ($.trim($("#txtccode").val()) == "") {
                $("#lblMsg").text('Please Enter Centre Code');
                $("#txtccode").focus();
                return false;
            }
            if ($.trim($("#txtMobile").val()) == "") {
                $("#lblMsg").text('Please Enter Contact No.');
                $("#txtMobile").focus();
                return false;
            }

            if ($.trim($("#txtMobile").val()).length < "8") {
                $('#lblMsg').text('Please Enter Valid Contact No.');
                $('#txtMobile').focus();
                return false;
            }
            if (($.trim($("#txtLandline").val()) != "") && ($.trim($("#txtLandline").val()).length < "8")) {
                $('#lblMsg').text('Please Enter Valid Landline No.');
                $('#txtLandline').focus();
                return false;
            }
            if ($("#ddlDiscount").val() == "0") {
                $('#lblMsg').text('Please Select Discount Type ');
                $('#ddlDiscount').focus();
                return false;
            }
            if ($.trim($("#txtCAddress").val()) == "") {
                $('#lblMsg').text('Please Enter Address ');
                $('#txtCAddress').focus();
                return false;
            }

            if ($("#chkSelf").prop("checked") == true && $('#txtInitialChar').val() == "")
            {
                $('#lblMsg').text('Please Enter Prefix ');
                $('#txtInitialChar').focus();
                return false;
            }
        }
    </script>
    <Ajax:ScriptManager ID="sc" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">

            <b>Centre Master</b>
            <br />

            <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError"></asp:Label>

            <asp:Label ID="lblselectedcenterid" runat="server" ClientIDMode="Static" Style="display: none"></asp:Label>

        </div>
        <div id="main_div" class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Centre Master Details
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Centre Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCName" runat="server" ClientIDMode="Static" CssClass="requiredField" MaxLength="50" TabIndex="1"></asp:TextBox>

                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Centre Code
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtccode" runat="server" ClientIDMode="Static" MaxLength="20" TabIndex="2" CssClass="requiredField" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Website
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtWebsite" runat="server" MaxLength="50" TabIndex="3"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Contact No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMobile" runat="server" MaxLength="15" TabIndex="4" CssClass="requiredField" ClientIDMode="Static"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="fltMobile" runat="server" FilterType="Numbers" TargetControlID="txtMobile">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Landline No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtLandline" runat="server" MaxLength="15" ClientIDMode="Static" TabIndex="5"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Numbers" TargetControlID="txtLandline">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Email Address
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMail" runat="server" onblur="email(this);" TabIndex="6" ClientIDMode="Static"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Discount Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDiscount" runat="server" CssClass="requiredField" TabIndex="7" ClientIDMode="Static">
                                <asp:ListItem Value="0">Select</asp:ListItem>
                                <asp:ListItem Value="Cash">Cash</asp:ListItem>
                                <asp:ListItem Value="Corporate">Corporate</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <%-- <div class="col-md-3">
                            <label class="pull-left">
                                Add Master
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Button ID="btnDoctor" TabIndex="25" Text="Map Doctor" Class="ItDoseButton" Visible="true" runat="server" OnClick="btnDoctor_Click" />
                            &nbsp;<asp:Button ID="btnPanel" TabIndex="25" Text="Map Panel" Class="ItDoseButton" Visible="true" runat="server" OnClick="btnPanel_Click" />
                        </div>--%>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Address
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCAddress" runat="server" TextMode="MultiLine" TabIndex="8" ClientIDMode="Static" CssClass="requiredField" MaxLength="200"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Country </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlCountry" OnSelectedIndexChanged="ddlCountry_SelectedIndexChanged" AutoPostBack="true" data-title="Select Country" runat="server" CssClass="requiredField" TabIndex="9" ClientIDMode="Static">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">State </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlState" OnSelectedIndexChanged="ddlState_SelectedIndexChanged" AutoPostBack="true" data-title="Select State" runat="server" CssClass="requiredField" TabIndex="10" ClientIDMode="Static">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">District </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDistrict" OnSelectedIndexChanged="ddlDistrict_SelectedIndexChanged" AutoPostBack="true" data-title="Select District" runat="server" CssClass="requiredField" TabIndex="11" ClientIDMode="Static">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">City </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlCity" data-title="Select City" runat="server" CssClass="requiredField" TabIndex="12" ClientIDMode="Static">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Latitude
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtLatitude" runat="server" TabIndex="13" ClientIDMode="Static" MaxLength="20"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Longitude
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtLongitude" runat="server" TabIndex="14" ClientIDMode="Static" MaxLength="20"></asp:TextBox>
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkPrePrintedBarcode" runat="server" ClientIDMode="Static" Text="PrintedBarcode" TabIndex="15" /></label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPrePrintedBarcode" runat="server" ClientIDMode="Static" MaxLength="1" TabIndex="16"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">

                        <div class="col-md-3">
                            <label class="pull-left">
                                Follow IPD No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:CheckBox ID="chkSelf" runat="server" Checked="true" ClientIDMode="Static" Text="Self" TabIndex="17" onchange="showItinialChar()" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:Label ID="lblInitialCharCap" runat="server" ClientIDMode="Static"> Prefix </asp:Label>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtInitialChar" runat="server" ClientIDMode="Static" CssClass="requiredField" MaxLength="4" TabIndex="18"></asp:TextBox>
                            <asp:DropDownList ID="ddlFollowedCentre" Style="display: none;" runat="server" ClientIDMode="Static" TabIndex="19"></asp:DropDownList>

                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkIsCap" runat="server" ClientIDMode="Static" Text="IsCAP/ISO" TabIndex="20" /></label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:FileUpload ID="flIsCap" runat="server" TabIndex="21" />
                        </div>






                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Header Logo
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:FileUpload ID="HeaderLogoCrystalReport" runat="server" TabIndex="22" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Footer Logo
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:FileUpload ID="footerLogoCrystalReport" runat="server" TabIndex="23" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkIsNablCenter" runat="server" ClientIDMode="Static" Text="IsNablCentre" TabIndex="24" /></label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:FileUpload ID="flIsNabl" runat="server" TabIndex="25" />
                        </div>
                    </div>
                    <div class="row" id="divaddmaster" style="display: none" runat="server">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <%--   <asp:Label ID="lblActive" runat="server" Visible="false">Active </asp:Label>--%>
                                Active
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rbtActive" runat="server" RepeatDirection="Horizontal" Visible="false" TabIndex="26">
                                <asp:ListItem Value="1" Selected="True">Active</asp:ListItem>
                                <asp:ListItem Value="0">In-Active</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Add Master
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="button" value="Map Doctor/Panel" onclick="Mappaneldoctor()" tabindex="27" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-10">
                </div>
                <div class="col-md-2">
                    <asp:Button ID="btnSave" TabIndex="28" Text="Save" Class="ItDoseButton" Visible="true" runat="server" OnClick="btnSave_Click" OnClientClick="return validateCenterName();" />
                </div>
                <div class="col-md-2">
                    <asp:Button ID="btnUpdate" TabIndex="29" Text="Update" Class="ItDoseButton" Visible="false" runat="server" OnClick="btnUpdate_Click" OnClientClick="return validateCenterName();" />
                </div>
                <div class="col-md-10">
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td colspan="4">
                        <div class="Purchaseheader">
                            Centre Master List
                        </div>
                        <asp:Panel ID="Panel1" Height="250" ScrollBars="Horizontal" Style="margin-top: 2px" runat="server">
                            <asp:GridView ID="grvCentre" AutoGenerateColumns="False" runat="server" CssClass="GridViewStyle"
                                OnSelectedIndexChanged="grvCentre_SelectedIndexChanged" OnRowCommand="grvCentre_RowCommand" DataKeyNames="CentreID" Width="100%">
                                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                <RowStyle CssClass="GridViewItemStyle" />
                                <Columns>
                                    <asp:CommandField ShowSelectButton="true" SelectImageUrl="~/Images/edit.png" ButtonType="Image" HeaderText="Edit" SelectText="Edit">
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                        <ItemStyle CssClass="GridViewItemStyle" Width="40px" />
                                    </asp:CommandField>
                                    <asp:BoundField DataField="CentreCode" HeaderText="Centre Code">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="CentreName" HeaderText="Centre Name">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Website" HeaderText="Website">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    <asp:TemplateField Visible="False">
                                        <ItemTemplate>
                                            <asp:Label ID="lblCentreId1" runat="server" Text='<%#Eval("CentreID") %>'></asp:Label>
                                        </ItemTemplate>

                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Address" HeaderText="Address">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="MobileNo" HeaderText="Mobile No.">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="LandlineNo" HeaderText="Landline No.">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="EmailID" HeaderText="Email Address">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="DiscountType" HeaderText="Discount Type">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                     <asp:BoundField DataField="FollowedCentre" HeaderText="Follow IPD No.">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="InitialChar" HeaderText="Prefix">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>

                                    <asp:BoundField DataField="Latitude" HeaderText="Latitude">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Longitude" HeaderText="Longitude">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Status">
                                        <ItemTemplate>
                                            <asp:Label ID="lblIsActive" runat="server" Text='<%#Eval("IsActive").ToString()=="1"?"Active":"In-Active" %>'></asp:Label>
                                            <asp:Label ID="NablLogoPath" runat="server" Text='<%#Eval("NablLogoPath").ToString() %>' Visible="false"></asp:Label>
                                            <asp:Label ID="IsNableCentre" runat="server" Text='<%#Eval("IsNableCentre").ToString() %>' Visible="false"></asp:Label>
                                            <asp:Label ID="CapLogoPath" runat="server" Text='<%#Eval("CapLogoPath").ToString() %>' Visible="false"></asp:Label>
                                            <asp:Label ID="isCap" runat="server" Text='<%#Eval("isCap").ToString()%>' Visible="false"></asp:Label>
                                             <asp:Label ID="LabBarcodeAbbreviation" runat="server" Text='<%#Eval("LabBarcodeAbbreviation").ToString() %>' Visible="false"></asp:Label>
                                             <asp:Label ID="PrePrintedBarcode" runat="server" Text='<%#Eval("PrePrintedBarcode").ToString() %>' Visible="false"></asp:Label>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:TemplateField>

                                </Columns>
                            </asp:GridView>
                        </asp:Panel>
                    </td>
                </tr>
            </table>
        </div>
        <asp:Panel ID="pnlAddDoctor" runat="server" CssClass="pnlItemsFilter" Style="display: none; width: 720px; margin-left: -200px; margin-top: -20px; text-align: center;">
            <div class="Purchaseheader" id="dragHandle" runat="server">
                Select List
            </div>
            <div style="overflow: scroll; height: 400px; text-align: Center;">
                <asp:GridView ID="grdOption" runat="server" Width="702px" AutoGenerateColumns="False" TabIndex="5" CssClass="GridViewStyle">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>

                            <ItemStyle CssClass="GridViewItemStyle" Width="10px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <HeaderTemplate>
                                <asp:CheckBox ID="chkall" runat="server" onclick="javascript:SelectAllCheckboxes1(this);" />
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:CheckBox ID="chkSelect" Checked='<%# Util.GetBoolean(Eval("ischecked")) %>' runat="server" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" Width="30px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="Name" HeaderText="Name">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:TemplateField Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblID" runat="server" Text='<%# Eval("ID")%>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
            <div style="text-align: center">
                <asp:Button ID="btnAdd" TabIndex="25" Text="ADD" OnClick="btnAdd_Click" Class="ItDoseButton" runat="server" />
                <asp:Button ID="btnCancel" TabIndex="25" Text="Cancel" Class="ItDoseButton" runat="server" />
            </div>
        </asp:Panel>
        <asp:Button ID="btnh" TabIndex="25" Text="" Class="ItDoseButton" Style="display: none" runat="server" />
        <cc1:ModalPopupExtender ID="mdlView" runat="server" CancelControlID="btnCancel" TargetControlID="btnh"
            BackgroundCssClass="filterPupupBackground" PopupControlID="pnlAddDoctor">
        </cc1:ModalPopupExtender>
        <%-- </div>--%>
        <div>
            <asp:Label ID="lblIsOpened" runat="server" Style="display: none"></asp:Label>
            <asp:Label ID="lblIsUpdate" runat="server" Style="display: none"></asp:Label>
        </div>
    </div>
    </div>
</asp:Content>

