<%@ Page Language="C#" AutoEventWireup="true" CodeFile="VendorDetail.aspx.cs" Inherits="Design_Store_VendorDetail"
    MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="DropDownCheckBoxes" Namespace="Saplin.Controls" TagPrefix="asp" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {


            getCountryonInsert();

            if ($("#ddlcountry1 option:selected").index() > 0) {
                getStateonInsert($.trim($("#ddlcountry1").val()));
            }

            $(".getState1").change(function () {
                getStateonInsert($.trim($("#ddlcountry1").val()));
            });
            $(".getState").change(function () {
                getStateonUpdate($.trim($("#ddlcountry").val()));
            });
        });

        function getCountrylist() {
            getCountryonUpdate();
            getStateonUpdate($.trim($("#ddlcountry").val()));
        }

        function getCountryonInsert() {
            $("#ddlcountry1 option").remove();
            $.ajax({
                url: "VendorDetail.aspx/getCountry",
                data: '{ }',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    CountryData = $.parseJSON(result.d);
                    if (CountryData.length == 0) {
                        $("#ddlcountry1").append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        for (i = 0; i < CountryData.length; i++) {
                            $("#ddlcountry1").append($("<option></option>").val(CountryData[i].CountryID).html(CountryData[i].Name));
                        }
                        $("#ddlcountry1").val("14");
                    }
                },
                error: function (xhr, status) {
                    $("#ddlcountry1").attr("disabled", false);
                }
            });
        }

        function getStateonInsert(CountryID) {

            $("#ddlstate1 option").remove();
            $.ajax({
                url: "VendorDetail.aspx/getState",
                data: '{CountryID:"' + CountryID + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    StateData = $.parseJSON(result.d);
                    if (StateData.length == 0) {
                        $("#ddlstate1").append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        for (i = 0; i < StateData.length; i++) {
                            $("#ddlstate1").append($("<option></option>").val(StateData[i].StateID).html(StateData[i].StateName));
                        }
                    }
                },
                error: function (xhr, status) {
                    $("#ddlstate1").attr("disabled", false);
                }
            });
        }

        function getCountryonUpdate() {
            $("#ddlcountry option").remove();
            $.ajax({
                url: "VendorDetail.aspx/getCountry",
                data: '{ }',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    CountryData = $.parseJSON(result.d);
                    if (CountryData.length == 0) {
                        $("#ddlcountry").append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        for (i = 0; i < CountryData.length; i++) {
                            $("#ddlcountry").append($("<option></option>").val(CountryData[i].CountryID).html(CountryData[i].Name));
                        }
                        $("#ddlcountry").val("14");
                    }
                },
                error: function (xhr, status) {
                    $("#ddlcountry").attr("disabled", false);
                }
            });
        }

        function getStateonUpdate(CountryID) {

            $("#ddlstate option").remove();
            $.ajax({
                url: "VendorDetail.aspx/getState",
                data: '{CountryID:"' + CountryID + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    StateData = $.parseJSON(result.d);
                    if (StateData.length == 0) {
                        $("#ddlstate").append($("<option></option>").val("0").html("---No Data Found---"));

                    }
                    else {
                        for (i = 0; i < StateData.length; i++) {
                            $("#ddlstate").append($("<option></option>").val(StateData[i].StateID).html(StateData[i].StateName));
                        }
                        if ($("#HFStateID").val() != "")
                            $("#ddlstate").val($("#HFStateID").val());
                    }
                },
                error: function (xhr, status) {
                    $("#ddlstate").attr("disabled", false);
                }
            });
        }

    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            var chkHeader = $(".chkHeader input");
            var chkItem = $(".chkItem input");
            chkHeader.click(function () {
                chkItem.each(function () {
                    this.checked = chkHeader[0].checked;
                })
            });
            chkItem.each(function () {
                $(this).click(function () {
                    if (this.checked == false) { chkHeader[0].checked = false; }
                })
            });


            var chkHeaderUpdate = $(".chkHeaderUpdate input");
            var chkItemUpdate = $(".chkItemUpdate input");
            chkHeaderUpdate.click(function () {
                chkItemUpdate.each(function () {
                    this.checked = chkHeaderUpdate[0].checked;
                })
            });
            chkItemUpdate.each(function () {
                $(this).click(function () {
                    if (this.checked == false) { chkHeaderUpdate[0].checked = false; }
                })
            });

        });
    </script>

    <style type="text/css">
        .requiredField1 {
            width: 250px;
            height: 23px !important;
            border-radius: 4px;
        }
    </style>

    <script type="text/javascript">
        function CancelPopup() {
            $('#<%=txtVen1.ClientID%>,#<%=txtvenCode.ClientID%>,#<%=txtvenbank.ClientID%>,#<%=txtvenAcc.ClientID%>').val('');
            $('#<%=txtAdd1.ClientID%>,#<%=txtAdd2.ClientID%>,#<%=txtContact.ClientID%>,#<%=txtEmail.ClientID%>,#<%=txtvenShipDetail.ClientID%>,#<%=txtDLNo.ClientID%>,#<%=txtVAT.ClientID%>').val('');
            $('#<%=txtMob1.ClientID%>,#<%=txtCreditDays.ClientID%>,#<%=txtAdd3.ClientID%>,#<%=txtCountry.ClientID%>,#<%=txtCity1.ClientID%>,#<%=txtPinCode.ClientID %>').val('');
            $('#<%=ddlType.ClientID%>').prop('selectedIndex', 0);
            //$('#<%=ddlvCat.ClientID%>').prop('selectedIndex', 0);
            $('#<%=ddlVenPayment.ClientID%>').prop('selectedIndex', 0);
        }

        function validateDocContact() {

            if ($('#<%=txtVen1.ClientID %>').val() == "") {
                $('#<%=lblVMsg.ClientID %>').show();
                $('#<%=lblVMsg.ClientID %>').text('Please Enter Supplier Name');
                $('#<%=txtVen1.ClientID %>').focus();
                return false;
            }
            else {
                $('#<%=lblVMsg.ClientID %>').hide();
                $('#<%=lblVMsg.ClientID %>').text('');
            }

            var emailaddress = $('#<%=txtEmail.ClientID %>').val();
            var emailexp = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
            if ((emailexp.test(emailaddress) == false) && (emailaddress != "")) {
                $('#<%=lblVMsg.ClientID %>').show();
                $('#<%=lblVMsg.ClientID %>').text('Please Enter Valid Email Address');
                $('#<%=txtEmail.ClientID %>').val('');
                $('#<%=txtEmail.ClientID %>').focus();
                return false;
            }
            else {
                $('#<%=lblVMsg.ClientID %>').hide();
                $('#<%=lblVMsg.ClientID %>').text('');
            }

            if ($('#<%=txtMob1.ClientID %>').val() == "") {
                $('#<%=lblVMsg.ClientID %>').show();
                $('#<%=lblVMsg.ClientID %>').text('Please Enter Contact No.');
                $('#<%=txtMob1.ClientID %>').focus();
                return false;
            }
            else {
                $('#<%=lblVMsg.ClientID %>').hide();
                $('#<%=lblVMsg.ClientID %>').text('');
            }
            if ($('#<%=txtCreditDays.ClientID %>').val() == "") {
                $('#<%=lblVMsg.ClientID %>').show();
                $('#<%=lblVMsg.ClientID %>').text('Please Enter Credit Days');
                $('#<%=txtCreditDays.ClientID %>').focus();
                return false;
            }
            else {
                $('#<%=lblVMsg.ClientID %>').hide();
                $('#<%=lblVMsg.ClientID %>').text('');
            }


            if ($('#<%=txtMob1.ClientID %>').val().length < "10") {
                $('#<%=lblVMsg.ClientID %>').show();
                $('#<%=lblVMsg.ClientID %>').text('Contact No. Must be 10-15 Digit');
                $('#<%=txtMob1.ClientID %>').focus();
                return false;
            }
            else {
                $('#<%=lblVMsg.ClientID %>').hide();
                $('#<%=lblVMsg.ClientID %>').text('');
            }
            if ($('#<%=txtGstTinNo.ClientID %>').val() == "") {
                $('#<%=lblVMsg.ClientID %>').show();
                if (Resources.Resource.IsGSTApplicable == "1") {
                    $('#<%=lblVMsg.ClientID %>').text('Please Enter GSTIN No.');
                }
                else {
                    $('#<%=lblVMsg.ClientID %>').text('Please Enter VAT No.');
                }
                $('#<%=txtGstTinNo.ClientID %>').focus();
                return false;
            }
            else {
                $('#<%=lblVMsg.ClientID %>').hide();
                $('#<%=lblVMsg.ClientID %>').text('');
            }

            $("#HFCountryID1").val($("#ddlcountry1").val());
            $("#HFStateID1").val($("#ddlstate1").val());


        }
        function validateDocContactNew() {

            if ($('#<%=txtVendor.ClientID %>').val() == "") {
                $('#<%=lblVUpMsg.ClientID %>').show();
                $('#<%=lblVUpMsg.ClientID %>').text('Please Enter Supplier Name');
                $('#<%=txtVendor.ClientID %>').focus();
                return false;
            }
            else {
                $('#<%=lblVUpMsg.ClientID %>').hide();
                $('#<%=lblVUpMsg.ClientID %>').text('');
            }
            var emailaddress = $('#<%=txtEmail2.ClientID %>').val();
            var emailexp = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
            if ((emailexp.test(emailaddress) == false) && (emailaddress != "")) {
                $('#<%=lblVUpMsg.ClientID %>').show();
                $('#<%=lblVUpMsg.ClientID %>').text('Please Enter Valid Email Address');
                $('#<%=txtEmail2.ClientID %>').val('');
                $('#<%=txtEmail2.ClientID %>').focus();
                return false;
            }
            else {
                $('#<%=lblVUpMsg.ClientID %>').hide();
                $('#<%=lblVUpMsg.ClientID %>').text('');
            }

            if ($('#<%=txtMobile.ClientID %>').val() == "") {
                $('#<%=lblVUpMsg.ClientID %>').show();
                $('#<%=lblVUpMsg.ClientID %>').text('Enter Contact No.');
                $('#<%=txtMobile.ClientID %>').focus();
                return false;
            }
            else {
                $('#<%=lblVUpMsg.ClientID %>').hide();
                $('#<%=lblVUpMsg.ClientID %>').text('');
            }

            if ($('#<%=txtMobile.ClientID %>').val().length < "10") {
                $('#<%=lblVUpMsg.ClientID %>').show();
                $('#<%=lblVUpMsg.ClientID %>').text('Contact No. Must be 10-15 Digit');
                $('#<%=txtMobile.ClientID %>').focus();
                return false;
            }
            else {
                $('#<%=lblVUpMsg.ClientID %>').hide();
                $('#<%=lblVUpMsg.ClientID %>').text('');
            }
            if ($('#<%=txtCreditDays1.ClientID %>').val() == "") {
                $('#<%=lblVMsg.ClientID %>').show();
                $('#<%=lblVMsg.ClientID %>').text('Please Enter Credit Days');
                $('#<%=txtCreditDays1.ClientID %>').focus();
                return false;
            }
            else {
                $('#<%=lblVMsg.ClientID %>').hide();
                $('#<%=lblVMsg.ClientID %>').text('');
            }

            $("#HFCountryID").val($("#ddlcountry").val());
            $("#HFStateID").val($("#ddlstate").val());


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
            //List of special characters you want to restrict
            if (keychar == "#" || keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "45") || (keynum >= "91" && keynum <= "95") || (keynum >= "48" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }

            else {
                return true;
            }
        }

        function validatespace() {
            var Pname = $('#<%=txtVen1.ClientID %>').val();
            if (Pname.charAt(0) == ' ' || Pname.charAt(0) == '.' || Pname.charAt(0) == ',' || Pname.charAt(0) == '0') {
                $('#<%=txtVen1.ClientID %>').val('');
                Pname.replace(Pname.charAt(0), "");
                return false;
            }
        }
        function validatespace1() {
            var Pname = $('#<%=txtVendor.ClientID %>').val();
            if (Pname.charAt(0) == ' ' || Pname.charAt(0) == '.' || Pname.charAt(0) == ',' || Pname.charAt(0) == '0') {
                $('#<%=txtVendor.ClientID %>').val('');
                Pname.replace(Pname.charAt(0), "");
                return false;
            }
        }
        function validatespace2() {
            var Pname = $('#<%=txtVendorName.ClientID %>').val();
            if (Pname.charAt(0) == ' ' || Pname.charAt(0) == '.' || Pname.charAt(0) == ',' || Pname.charAt(0) == '0') {
                $('#<%=txtVendorName.ClientID %>').val('');
                Pname.replace(Pname.charAt(0), "");
                return false;
            }
        }
        function validateVendor() {
            if ($.trim($("#<%=txtVendorName.ClientID%>").val()) == "") {
                $("#<%=lblMsg.ClientID%>").text('Please Enter Supplier Name');
                $("#<%=txtVendorName.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=txtVendorName.ClientID%>").val()).length <= 2) {
                $("#<%=lblMsg.ClientID%>").text('Please Enter Atleast 3 Characters');
                $("#<%=txtVendorName.ClientID%>").focus();
                return false;
            }
        }
        $(function () {
            $("#btnAddNew").click(function () {
                showSaveSupplierModel();
                //$("#txtVen1").focus();
            });
        });

        var showSaveSupplierModel = function () {
            $("#divNewSupplier").showModel();
        }
        var showUpdateSupplierModel = function () {
            $("#divUpdateSupplier").showModel();
        }



    </script>

    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Supplier Master</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Supplier
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Supplier Name </label>
                    <b class="pull-right">:</b>
                </div>

                <div class="col-md-8">
                    <asp:TextBox ID="txtVendorName" CssClass="requiredField" ClientIDMode="Static" onkeyup="validatespace2();" runat="server"> </asp:TextBox>
                </div>
                <div class="col-md-2">
                    <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" CssClass="ItDoseButton" OnClientClick="return validateVendor()" />
                </div>
                <div class="col-md-2">
                    <input type="button" class="ItDoseButton" id="btnAddNew" value="Add New" />
                </div>
                <div class="col-md-2">
                    <asp:Button ID="btnReport" Text="Report" runat="server" CssClass="ItDoseButton" />
                </div>
                <div class="col-md-7">
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Results
            </div>
            <div class="">
                <asp:GridView ID="grdVendor" runat="server" AutoGenerateColumns="False" AllowPaging="True"
                    CssClass="GridViewStyle" OnPageIndexChanging="grdVendor_PageIndexChanging" OnRowCommand="grdVendor_RowCommand"
                    PageSize="15" Width="100%">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Supplier Type">
                            <ItemTemplate>
                                <%#Eval("VendorType")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="100px" />

                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Category">
                            <ItemTemplate>
                                <%#Eval("VendorCategory") %>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="200px" />

                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Name">
                            <ItemTemplate>
                                <%#Eval("VendorName") %>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="200px" />

                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="GST No">
                            <ItemTemplate>
                                <%#Eval("Ven_GSTINNo") %>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="200px" />

                        </asp:TemplateField>


                        <%--<asp:TemplateField HeaderText="TIN No." >
                    <ItemTemplate>
                    <%#Eval("VATNo") %>
                    </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        <ItemStyle CssClass="GridViewItemStyle" Width="100px" />
                    
                    </asp:TemplateField>--%>
                        <asp:TemplateField HeaderText="Address1">
                            <ItemTemplate>
                                <%#Eval("Address1")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="150px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Address2">
                            <ItemTemplate>
                                <%#Eval("Address2") %>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="150px" />

                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Address3">
                            <ItemTemplate>
                                <%#Eval("Address3") %>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="150px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="City">
                            <ItemTemplate>
                                <%#Eval("City") %>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="75px" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Country">
                            <ItemTemplate>
                                <%#Eval("Country") %>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Mobile No.">
                            <ItemTemplate>
                                <%#Eval("Mobile") %>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="100px" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Telephone No" Visible="false">
                            <ItemTemplate>
                                <%#Eval("Telephone") %>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="100px" />
                        </asp:TemplateField>


                        <asp:TemplateField HeaderText="Edit">
                            <ItemTemplate>
                                <asp:Label ID="lblVendorId" Text='<%# Eval("Vendor_ID") %>' runat="server" Visible="False"></asp:Label>
                                <asp:ImageButton ID="imbModify" ToolTip="Modify Item" runat="server" ImageUrl="~/Images/edit.png" CausesValidation="false" CommandArgument='<%# Eval("Vendor_ID") %>'
                                    CommandName="AEdit" OnClientClick="return getCountrylist();" />
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

    <div id="divNewSupplier" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 915px;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divNewSupplier" aria-hidden="true">×</button>
                    <h4 class="modal-title">Add New Supplier  &nbsp;&nbsp;   <asp:Label ID="lblVMsg" runat="server" CssClass="ItDoseLblError"></asp:Label></h4>
                    
                </div>

                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Supplier Type </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:DropDownList ID="ddlType" runat="server" Width="250px">
                                <asp:ListItem>GENERAL</asp:ListItem>
                                <asp:ListItem>URGENT</asp:ListItem>
                                <asp:ListItem>ASSET</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Category</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:DropDownList ID="ddlvCat" runat="server" Width="250px">
                                <asp:ListItem>MEDICAL ITEMS</asp:ListItem>
                                <asp:ListItem>GENERAL ITEMS</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Supplier Code </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtvenCode" runat="server" Width="250px" MaxLength="20"></asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtVen1" CssClass="requiredField" runat="server" Font-Bold="true" Width="250px" MaxLength="50"
                                ClientIDMode="Static" onkeyup="validatespace();"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Address1 </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtAdd1" runat="server" Width="250px" MaxLength="100"></asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Postal Code</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtPinCode" runat="server" MaxLength="10" Width="250px">
                            </asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtPinCode"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Address2 </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtAdd2" runat="server" Width="250px" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">City</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtCity1" runat="server" Width="250px" MaxLength="50" ClientIDMode="Static" onkeypress="return check(event)"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Address3 </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtAdd3" runat="server" Width="250px" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Credit Days</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtCreditDays" CssClass="requiredField" runat="server" MaxLength="15" Width="250px">
                            </asp:TextBox><span style="color: Red; font-size: 10px;">&nbsp;</span>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtCreditDays"
                                FilterType="Custom, Numbers" ValidChars="0987654321" Enabled="True">
                            </cc1:FilteredTextBoxExtender>

                            <asp:TextBox ID="txtCountry" runat="server" Width="250px" Style="display: none;"
                                MaxLength="50" ClientIDMode="Static" onkeypress="return check(event)">
                            </asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Contact Person </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtContact" runat="server" Width="250px" MaxLength="100" ClientIDMode="Static" onkeypress="return check(event)"></asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Telephone No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtMob1" runat="server" CssClass="requiredField" MaxLength="15" Width="250px">
                            </asp:TextBox>&nbsp;<span style="color: Red; font-size: 10px;"></span>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender6" runat="server" TargetControlID="txtMob1"
                                FilterType="Custom, Numbers" ValidChars="0987654321" Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">E-Mail </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtEmail" runat="server" MaxLength="50" Width="250px"></asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Bank Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtvenbank" runat="server" Width="250px" MaxLength="100" ClientIDMode="Static" onkeypress="return check(event)"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Account No. </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtvenAcc" runat="server" Width="250px" MaxLength="20"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender8" runat="server" TargetControlID="txtvenAcc"
                                FilterType="Numbers" Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Payment Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                             <asp:DropDownList ID="ddlVenPayment" runat="server" Width="250px">
                                <asp:ListItem>CASH</asp:ListItem>
                                <asp:ListItem>CREDIT</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Shipment Detail </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtvenShipDetail" runat="server" Width="250px" MaxLength="100" ClientIDMode="Static" onkeypress="return check(event)"></asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">TIN No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtVAT" runat="server" Width="250px" MaxLength="50"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row" style="display: none;">
                        <div class="col-md-4">
                            <label class="pull-left">DL No. </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtDLNo" runat="server" MaxLength="50" Width="250px"></asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Telephone</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtTel1" runat="server" MaxLength="200"></asp:TextBox>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Country</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:DropDownList ID="ddlcountry1" runat="server" Width="250px" ClientIDMode="Static" CssClass="getState1">
                            </asp:DropDownList>
                            <asp:HiddenField ID="HFCountryID1" runat="server" ClientIDMode="Static" />
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">State</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:DropDownList ID="ddlstate1" runat="server" Width="250px" ClientIDMode="Static">
                            </asp:DropDownList>
                            <asp:HiddenField ID="HFStateID1" runat="server" ClientIDMode="Static" />
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                <%if (Resources.Resource.IsGSTApplicable == "1")
                                  { %> GSTIN No. <%}
                                  else
                                  { %> VAT No. <%} %>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtGstTinNo" CssClass="requiredField" runat="server" Width="250px" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Is Asset </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <div style="display: none;">
                                <asp:DropDownCheckBoxes ID="ddlDeptName" runat="server" AddJQueryReference="True" UseButtons="false" UseSelectAllNode="True" Height="23px" CssClass="requiredField">
                                    <Texts SelectBoxCaption="Select all" />
                                </asp:DropDownCheckBoxes>
                            </div>
                            <asp:CheckBox ID="chkIsAsset" runat="server" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                               Supplier Currency
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                           <asp:DropDownList ID="ddlSupplierCurrency" runat="server" Width="250px"></asp:DropDownList>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Is Insurance  Provider</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                             <asp:CheckBox ID="chkInsuranceProvider" runat="server" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-24">
                            <div class="Purchaseheader">
                                Terms Condition Details
                            </div>
                            <asp:GridView ID="grdTerms" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" Style="width: auto; height: auto"
                                PageSize="5">
                                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No.">
                                        <ItemTemplate>
                                            <%# Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                        <ItemStyle CssClass="GridViewItemStyle" Width="30px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="#">
                                        <ItemStyle CssClass="GridViewItemStyle" Width="40px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                        <HeaderTemplate>
                                            <asp:CheckBox runat="server" ID="chkSelectAll" CssClass="chkHeader" Text="All" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkSelect" CssClass="chkItem" runat="server" />
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                        <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Terms And Condition" ItemStyle-HorizontalAlign="Left">
                                        <ItemTemplate>
                                            <asp:Label ID="lblTerms" runat="server" Text='<%#Eval("Terms")%>'></asp:Label>
                                            <asp:Label ID="lblTermsId" runat="server" Text='<%#Eval("Id")%>' Visible="false"></asp:Label>

                                        </ItemTemplate>
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="800px" HorizontalAlign="Left" />
                                        <ItemStyle CssClass="GridViewItemStyle" Width="800px" HorizontalAlign="Left" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="save" ValidationGroup="Save"
                        OnClick="btnSave_Click" OnClientClick="return validateDocContact();" />
                    <button type="button" class="save" data-dismiss="divNewSupplier">Close</button>
                </div>
            </div>
        </div>
    </div>
    <div id="divUpdateSupplier" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 915px;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divUpdateSupplier" aria-hidden="true">×</button>
                    <h4 class="modal-title">Update Supplier &nbsp;&nbsp;  <asp:Label ID="lblVUpMsg" runat="server" CssClass="ItDoseLblError"></asp:Label></h4>
                   
                </div>

                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Supplier Type </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:DropDownList ID="ddlType2" runat="server"   Width="250px">
                                <asp:ListItem>GENERAL</asp:ListItem>
                                <asp:ListItem>URGENT</asp:ListItem>
                                <asp:ListItem>ASSET</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Category</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:DropDownList ID="ddlvCat2"   runat="server" Width="250px">
                                <asp:ListItem>GENERAL ITEMS</asp:ListItem>
                                <asp:ListItem>MEDICAL ITEMS</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Supplier Code </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtvenCode2"   runat="server" Width="250px"
                                MaxLength="20">
                            </asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtVendor"   CssClass="requiredField" runat="server" Font-Bold="true" ClientIDMode="Static"
                                onkeyup="validatespace1();" onkeypress="return check(event)"
                                Width="250px" MaxLength="50"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Address1</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtAddress1"   runat="server" Width="250px"
                                MaxLength="100">
                            </asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Postal Code</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtPinCode2"   runat="server" MaxLength="20" Width="250px">
                            </asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" TargetControlID="txtPinCode2"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Address2</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtAddress2"   runat="server" Width="250px"
                                MaxLength="50">
                            </asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">City</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtCity2"   runat="server" ClientIDMode="Static"
                                onkeypress="return check(event)" Width="250px" MaxLength="50">
                            </asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Address3</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtAddress3"   runat="server" Width="250px"
                                MaxLength="50">
                            </asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Credit Days</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtCreditDays1"   runat="server" MaxLength="200" CssClass="requiredField" Width="250px">
                            </asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" TargetControlID="txtCreditDays1"
                                FilterType="Custom, Numbers" ValidChars="0987654321" Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                            <asp:TextBox ID="txtCountry2" Enabled="false" ClientIDMode="Static" onkeypress="return check(event)" Style="display: none;"
                                runat="server" MaxLength="50" Width="250px">
                            </asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Contact Person</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtContactPerson2"   runat="server" ClientIDMode="Static" onkeypress="return check(event)"
                                MaxLength="100" Width="250px">
                            </asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Telephone No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtMobile"   runat="server" MaxLength="15" CssClass="requiredField" Width="250px">
                            </asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender7" runat="server" TargetControlID="txtMobile"
                                FilterType="Custom, Numbers" ValidChars="0987654321" Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">E-Mail</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtEmail2"   runat="server" MaxLength="50"
                                Width="250px">
                            </asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Bank Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtvenbank2"   runat="server" Width="250px"
                                MaxLength="100" ClientIDMode="Static" onkeypress="return check(event)">
                            </asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Account No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtvenAcc2"   runat="server" Width="250px"
                                MaxLength="20">
                            </asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender9" runat="server" TargetControlID="txtvenAcc2"
                                FilterType="Numbers" Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Payment Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:DropDownList ID="ddlVenPayment2"   runat="server" Width="250px">
                                <asp:ListItem>CASH</asp:ListItem>
                                <asp:ListItem>CREDIT</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Shipment Detail</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtvenShipDetail2"   runat="server" Width="250px"
                                MaxLength="100" ClientIDMode="Static" onkeypress="return check(event)">
                            </asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">LIC No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtVATNo2"  runat="server" Font-Bold="true"
                                Width="250px" MaxLength="50">
                            </asp:TextBox>
                        </div>
                    </div>
                    <div class="row" style="display: none;">
                        <div class="col-md-4">
                            <label class="pull-left">DL No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtDLNo2" Enabled="false" runat="server" Font-Bold="true"
                                MaxLength="50" Width="250px">
                            </asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Telephone</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtPhone" Enabled="false" runat="server" MaxLength="15"
                                Style="display: none;">
                            </asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" TargetControlID="txtPhone"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Country</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:DropDownList ID="ddlcountry" runat="server"  Width="250px" ClientIDMode="Static" CssClass="getState">
                            </asp:DropDownList>
                            <asp:HiddenField ID="HFCountryID" runat="server" ClientIDMode="Static" />
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">State</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:DropDownList ID="ddlstate" runat="server"  Width="250px" ClientIDMode="Static">
                            </asp:DropDownList>
                            <asp:HiddenField ID="HFStateID" runat="server" ClientIDMode="Static" />
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                <%if (Resources.Resource.IsGSTApplicable == "1")
                                  { %> GSTIN No. <%}
                                  else
                                  { %> VAT No. <%} %>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtGstInNoUpdate"  CssClass="requiredField" runat="server" Font-Bold="true"
                                MaxLength="50" Width="250px">
                            </asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Is Asset</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <div style="display: none;">
                                <asp:DropDownCheckBoxes ID="ddldeptupdate" runat="server" AddJQueryReference="True" UseButtons="false" UseSelectAllNode="True" Height="23px" CssClass="requiredField">
                                    <Texts SelectBoxCaption="Select all" />
                                </asp:DropDownCheckBoxes>
                            </div>
                            <asp:CheckBox ID="chkUpdateIsAsset" runat="server" />
                        </div>
                    </div>
                     <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                               Supplier Currency
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                           <asp:DropDownList ID="ddlSupplierCurrency2" runat="server" Width="250px"></asp:DropDownList>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Is Insurance Provider</label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-8">
                           <asp:CheckBox ID="chkUpdateIsInsurance" runat="server" />
                        </div>
                    </div>
                    <div class="row">

                        <div class="col-md-24">
                            <div class="Purchaseheader" style="text-align: left;">
                                Terms Condition Details
                            </div>

                            <asp:GridView ID="grdTermsUpdate" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                PageSize="5" Width="870px">
                                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No.">
                                        <ItemTemplate>
                                            <%# Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                        <ItemStyle CssClass="GridViewItemStyle" Width="30px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="#">
                                        <ItemStyle CssClass="GridViewItemStyle" Width="40px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                        <HeaderTemplate>
                                            <asp:CheckBox runat="server" ID="chkSelectAll" CssClass="chkHeaderUpdate" Text="All" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkSelect" CssClass="chkItemUpdate" Checked='<%# Util.GetBoolean(Eval("IsCheck")) %>' runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Terms And Condition" ItemStyle-HorizontalAlign="Left">
                                        <ItemTemplate>
                                            <asp:Label ID="lblTerms" runat="server" Text='<%#Eval("Terms")%>'></asp:Label>
                                            <asp:Label ID="lblTermsId" runat="server" Text='<%#Eval("Id")%>' Visible="false"></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="750px" HorizontalAlign="Left" />
                                        <ItemStyle CssClass="GridViewItemStyle" Width="750px" HorizontalAlign="Left" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnupdate" runat="server" Text="Update" CssClass="save" ValidationGroup="Update" OnClick="btnupdate_Click" OnClientClick="return validateDocContactNew();" />
                    <button type="button" class="save" data-dismiss="divUpdateSupplier">Close</button>
                </div>
            </div>
        </div>
    </div>


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
            <asp:Button ID="btnItemCancel1" runat="server" CssClass="ItDoseButton" Text="Cancel" />
        </div>

    </asp:Panel>
    <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" CancelControlID="btnItemCancel1"
        DropShadow="true" TargetControlID="btnReport" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlAddGroup" PopupDragHandleControlID="dragHandle">
    </cc1:ModalPopupExtender>

    <script type="text/javascript" src="../../Scripts/Common.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.slimscroll.js"></script>
    <script type="text/javascript" src="../../Scripts/chosen.jquery.min.js"></script>
</asp:Content>
