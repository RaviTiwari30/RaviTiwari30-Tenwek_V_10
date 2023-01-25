<%@ Page Language="C#" MaintainScrollPositionOnPostback="true" AutoEventWireup="true"
    CodeFile="IPDPackageBilling.aspx.cs" Inherits="Design_IPD_IPDPackageBilling" EnableEventValidation="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../../Styles/easyui.css" />
    <link rel="Stylesheet" type="text/css" href="../../Scripts/chosen.css" />
    <script type="text/javascript" src="../../Scripts/Search.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js" ></script>
    <script type="text/javascript" src="../../Scripts/Common.js"></script>
    <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
    <script  src="../../Scripts/json2.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/chosen.jquery.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script> 


  <%--    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript" src="../../Scripts/Search.js"></script>
    <link rel="Stylesheet" type="text/css" href="../../Scripts/chosen.css" />
    <script type="text/javascript" src="../../Scripts/chosen.jquery.js"></script>--%>





    <style type="text/css">
        .style2
        {
            width: 20%;
            height: 29px;
            text-align: right;
        }

        .style3
        {
            width: 40%;
            height: 29px;
        }

        .style4
        {
            width: 20%;
        }
         .hidden {
            display: none !important;
        }
    </style>
</head>
<body>
    <script type="text/javascript">

        $(document).ready(function () {
            $("#<%=txtQty.ClientID %>").bind("blur keyup keydown", function () {
                if (($("#<%=txtQty.ClientID %>").val() == "0") || ($("#<%=txtQty.ClientID %>").val() == "") || ($("#<%=txtQty.ClientID %>").val().charAt(0) == "0")) {
                    $("#<%=txtQty.ClientID %>").val(1);

                }
            });
        });
    </script>
    <script type="text/javascript">
        var Ok;
        function ConfirmSave(EntryDt, Name) {
            Ok = confirm('This Service is Already Prescribed By ' + Name + ' Date On ' + EntryDt + '. Do You Want To Prescribe Again ???');
            if (Ok) {
                var btn = document.getElementById("<%=btnAddDirect.ClientID %>");
                btn.click();
            }
            else {
                var btnCancel = document.getElementById("<%=Button2.ClientID %>");
                btnCancel.click();
            }


        }

    </script>
    <script type="text/javascript">
        function ValidateCharactercount(charlimit, cont) {
            var id = "#" + cont.id;
            if ($(id).text().length > charlimit) {
                $(id).text($(id).text().substring(0, charlimit));
                //            $("#divmessage").html("Maximum cahracter allowes :" + charlimit);
            }
        }

        var keys = [];
        var values = [];
        $(document).ready(function () {
            var options = $('#<% = ListBox1.ClientID %> option');
            $.each(options, function (index, item) {
                keys.push(item.value);
                values.push(item.innerHTML);
            });

            $('#<% = txtFirstNameSearch.ClientID %>').keyup(function (e) {
                searchByFirstChar(document.getElementById('<%=txtFirstNameSearch.ClientID%>'), document.getElementById('<%=txtCPTCodeSearch.ClientID%>'), document.getElementById('<%=txtInBetweenSearch.ClientID%>'), document.getElementById('<%=ListBox1.ClientID%>'), document.getElementById('btnSelect'), values, keys, e)
                LoadDetail();
            });
            $('#<%=txtCPTCodeSearch.ClientID %>').keyup(function (e) {
                searchByCPTCode(document.getElementById('<%=txtFirstNameSearch.ClientID%>'), document.getElementById('<%=txtCPTCodeSearch.ClientID%>'), document.getElementById('<%=txtInBetweenSearch.ClientID%>'), document.getElementById('<%=ListBox1.ClientID%>'), document.getElementById('btnSelect'), values, keys, e)
                LoadDetail();
            });
            $('#<%=txtInBetweenSearch.ClientID %>').keyup(function (e) {
                searchByInBetween(document.getElementById('<%=txtFirstNameSearch.ClientID%>'), document.getElementById('<%=txtCPTCodeSearch.ClientID%>'), document.getElementById('<%=txtInBetweenSearch.ClientID%>'), document.getElementById('<%=ListBox1.ClientID%>'), document.getElementById('btnSelect'), values, keys, e)
                LoadDetail();
            });


        });
        function chkSelectAll(fld) {
            var gridTable = document.getElementById("<%=grdItemRate.ClientID %>");
            var chkList = gridTable.getElementsByTagName("input");
            for (var i = 0; i < chkList.length; i++) {
                if (chkList[i].type == "checkbox") {
                    chkList[i].checked = fld.checked;
                }
            }
        }
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
    </script>
    <script type="text/javascript">
        function LoadDetail() {
            var strItem = $('#<%=ListBox1.ClientID %>').val();
            if (strItem != null) {
                var ItemID = strItem.split('#')[0];
                //getPackageDetail(ItemID);
                $('#SpnValidity').text("");
                serverCall('IPDPackageBilling.aspx/getPackageDetail', { ItemID: ItemID }, function (response) {
                    PackageDetail = jQuery.parseJSON(response);
                    if (PackageDetail != null) {
                        var ValidityDays = parseInt(PackageDetail[0]["ValidityDays"]);
                        $('#SpnValidity').text("Validity Days : " + ValidityDays);
                        var Fromdate = new Date($('#ucDate').val());
                        Fromdate.setDate(Fromdate.getDate() + ValidityDays);
                        var dd = Fromdate.getDate();
                        var mm = getmonthname(Fromdate);
                        var y = Fromdate.getFullYear();
                        var DateFormat = dd + '-' + mm + '-' + y;
                        $('#toDate').val(DateFormat);
                    }
                });
            }
        }
        var getmonthname = function (dt) {
            mlist = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
            return mlist[dt.getMonth()];
        }

        function CalulateValidityDays() {
            var Fromdate = new Date($('#ucDate').val());
            var Todate = new Date($('#toDate').val());
            Totaldays = (Todate - Fromdate) / (1000 * 60 * 60 * 24);
            if (parseInt(Totaldays) >= 0)
                $('#SpnNewValidDays').text("New Validity Days : " + Totaldays);
            else
                $('#SpnNewValidDays').text("");
        }

        var Openpackagemodal = function () {
            if (!String.isNullOrEmpty($('#ListBox1 option:selected').val())) {
                $('#spnPackageID').text($('#ListBox1 option:selected').val().split('#')[0]);
                $('#spnPackageName').text($('#ListBox1 option:selected').text().split('#')[1]);
                $('#divpkg').removeClass('hidden');
                bindPackageServiceDetail($('#ListBox1 option:selected').val().split('#')[0])
            }
            $('#divPackageService').showModel();
        }

        var getPackageDetail = function (elem) {
            if (elem ==0) {
                $('#divpkg').removeClass('hidden');
                $('#ddlPrescribedPackages').val(0);
                $('#divOutput').html('');
            }
            else {
                $('#divpkg').addClass('hidden');
                bindPackageServiceDetail(elem);
            }
        }

        var bindPackageServiceDetail = function (PackageItemID) {
            serverCall('IPDPackageBilling.aspx/bindPackageDetail', { IPDNo: $.trim($('#lblTransactionNo').text()), PackageID: PackageItemID }, function (response) {
                ResultData = jQuery.parseJSON(response);
                var output = $('#tb_PackageDetail').parseTemplate(ResultData);
                $('#divOutput').html(output);
                $('#divOutput').show();
            });
        }


    </script>
    <form id="form1" runat="server">
        <script type="text/javascript">
            $(document).ready(function () {
                $('#ucFromDate').change(function () {
                    ChkDate();
                    ChangeFromDateToDate();
                });

                $('#ucToDate').change(function () {
                    ChkDate();
                    ChangeFromDateToDate();
                });
            });
            function ChkDate() {
                $.ajax({
                    url: "../common/CommonService.asmx/CompareDate",
                    data: '{DateFrom:"' + $('#ucDate').val() + '",DateTo:"' + $('#toDate').val() + '"}',
                    type: "POST",
                    async: true,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (mydata) {
                        var data = mydata.d;
                        if (data == false) {
                            $('#lblMsg').text('To date can not be less than from date!');
                            $('#btnSelect').attr('disabled', 'disabled');
                        }
                        else {
                            $('#lblMsg').text('');
                            $('#btnSelect').removeAttr('disabled');
                        }
                    }
                });

            }
        </script>
        <script type="text/javascript">
            if ($.browser.msie) {
                $(document).on("keydown", function (e) {
                    var doPrevent;
                    if (e.keyCode == 8) {
                        var d = e.srcElement || e.target;
                        if (d.tagName.toUpperCase() == 'INPUT' || d.tagName.toUpperCase() == 'TEXTAREA') {
                            doPrevent = d.readOnly
                                || d.disabled;
                        }
                        else
                            doPrevent = true;
                    }
                    else
                        doPrevent = false;
                    if (doPrevent) {
                        e.preventDefault();
                    }
                });
            }
        </script>
        <script type="text/javascript">
            function chkValidation() { 
                if (($.trim($("#<%=txtQty.ClientID%>").val()) == "") || ($.trim($("#<%=txtQty.ClientID%>").val()) < "0")) {
                    $("#<%=lblMsg.ClientID%>").text('Please Enter Quantity');
                    $("#<%=txtQty.ClientID%>").focus();
                    return false;
                }
                if ($("#<%=ListBox1.ClientID%>").val().split('#')[4] == "1") {
                    var Ok = confirm('This Item is Non Payable.Do You Want To Prescribe');
                    if (Ok) {
                        __doPostBack('btnSelect', '');
                    }
                    else {
                        return false;
                    }
                }
            }
            function RestrictDoubleEntry(btn) {
                if (Page_IsValid) {
                    btn.disabled = true;
                    btn.value = 'Submitting...';
                    __doPostBack('btnReceipt', '');
                }
            }
            function checkQty(rowID) {
                if ($.trim($(rowID).val()) == 0 || $.trim($(rowID).val()) == "") {
                    $(rowID).val(1);
                }
            }
            function checkForSecondDecimalQty(sender, e) {
                formatBox = document.getElementById(sender.id);
                strLen = sender.value.length;
                strVal = sender.value;
                hasDec = false;
                e = (e) ? e : (window.event) ? event : null;
                if (sender.value == "1") {
                    sender.value = sender.value.substring(0, sender.value.length - 1);
                }
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
        </script>
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>IPD Package</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>

            </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-24">
                        <div class="row" style="display:none">
                            <div class="col-md-4">
                                <label class="pull-left">Category</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlCategory" runat="server" Width="258px" AutoPostBack="True"
                                    OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged" TabIndex="1" ToolTip="Select Category" />
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left"></label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Search by first Name</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtFirstNameSearch" runat="server" AutoCompleteType="Disabled" Width=""
                                    TabIndex="2" ToolTip="Enter To Select Item"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Search by CPT Code
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtCPTCodeSearch" runat="server" onkeyup="javascript:ValidateCharactercount(10,this);"
                                    Width="" ToolTip="Enter CPT Code To Search Surgery" TabIndex="5"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <input type="button" id="btnPackageItems" value="Package Services Status" title="Click to get Status of all items in this package" onclick="Openpackagemodal();" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Search in Between
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtInBetweenSearch" runat="server" AutoCompleteType="Disabled"
                                    Width="" />
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left"></label>
                                <b class="pull-right"></b>
                            </div>
                            <div class="col-md-5">
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-md-4">
                            </div>
                            <div class="col-md-14">
                                <asp:ListBox ID="ListBox1" runat="server" Height="144px" Width="" ToolTip="Select Item" onchange="LoadDetail();"
                                    TabIndex="3"></asp:ListBox>
                                <asp:TextBox ID="txtDocCharges" runat="server" Text="0" CssClass="ItDoseTextinputNum"
                                    Width="75px" Visible="false" />
                                <cc1:FilteredTextBoxExtender ID="fl1" runat="server" FilterType="Custom,Numbers"
                                    ValidChars="." TargetControlID="txtDocCharges" />
                            </div>
                            <div class="col-md-6">
                                 <span id="SpnValidity" style="font-size: large; color: red;"></span>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Doctor</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="cmbRefferedBy" runat="server" Width="" ToolTip="Select Doctor"
                                    TabIndex="4" />
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Qunatity</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtQty" Text="1" runat="server"
                                    Width="" CssClass="ItDoseTextinputNum" TabIndex="6" ToolTip="Enter Quantity" AutoCompleteType="Disabled"
                                    MaxLength="3" onkeypress="return checkForSecondDecimalQty(this,event)" onkeyup="return checkQty(this)" />
                                <cc1:FilteredTextBoxExtender ID="ftbQty" runat="server" FilterType="Numbers"
                                    TargetControlID="txtQty" />
                            </div>
                            <div class="col-md-6">
                                <span id="SpnNewValidDays" style="font-size: large; color: red;"></span>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">From Date</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="ucDate" runat="server" ToolTip="Click to Select Date" TabIndex="5"
                                    Width="" onchange="ChkDate();CalulateValidityDays();"></asp:TextBox>
                                <cc1:CalendarExtender ID="calucDate" runat="server" TargetControlID="ucDate" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">To Date</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="toDate" runat="server" ToolTip="Click to Select Date" TabIndex="5"
                                    Width="" onchange="ChkDate();CalulateValidityDays();"></asp:TextBox>
                                <cc1:CalendarExtender ID="caltoDate" runat="server" TargetControlID="toDate" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <div class="content" style="text-align: center;">
                    <asp:Button ID="btnSelect" runat="server" CssClass="ItDoseButton" Text="Select" OnClick="btnSelect_Click"
                        TabIndex="7" ToolTip="Click To Add Item" />
                </div>
            </div>
            <asp:Panel ID="pnlhide" runat="server" Visible="false">
                <div class="POuter_Box_Inventory" style="text-align: center">
                    <div class="Purchaseheader">
                        Service Items
                    </div>
                    <div class="content" style="text-align: center;">
                        <asp:GridView ID="grdItemRate" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False"
                            OnRowDeleting="grdItemRate_RowDeleting">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Category" HeaderText="Category" HeaderStyle-Width="120px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle"
                                    ItemStyle-HorizontalAlign="Left" />
                                <asp:BoundField DataField="SubCategory" HeaderText="Sub Category" Visible="false"
                                    HeaderStyle-Width="155px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle"
                                    ItemStyle-HorizontalAlign="Left" />
                                <asp:BoundField DataField="Item" HeaderText="Item" HeaderStyle-Width="165px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-HorizontalAlign="Left" />


                                <asp:TemplateField HeaderText="Quantity" HeaderStyle-Width="75px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" Visible="false">
                                    <ItemTemplate>
                                        <asp:TextBox AccessKey="q" ID="txtQuantity" runat="server" Width="65px" Text='<%# Eval("Quantity") %>' AutoCompleteType="Disabled"
                                            CssClass="ItDoseTextinputNum" MaxLength="3" onkeypress="return checkForSecondDecimalQty(this,event)" onkeyup="return checkQty(this)" />
                                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Numbers"
                                            TargetControlID="txtQuantity" />
                                        <asp:RequiredFieldValidator ID="rq1" runat="server" Display="None" Text="*" ErrorMessage="Specify Quantity"
                                            SetFocusOnError="true" ControlToValidate="txtQuantity" />

                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Rate" HeaderStyle-Width="75px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtRate" runat="server" Text='<%# Eval("Rate") %>' Width="65px" CssClass="ItDoseTextinputNum" AutoCompleteType="Disabled"
                                            MaxLength="8" onkeypress="return checkForSecondDecimal(this,event)" />
                                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" ValidChars="0123456789."
                                            TargetControlID="txtRate" />
                                        <asp:RequiredFieldValidator ID="rq2" runat="server" Display="None" Text="*" ErrorMessage="Specify Rate"
                                            SetFocusOnError="true" ControlToValidate="txtRate" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Date" HeaderText="Date" HeaderStyle-Width="90px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" Visible="false" />
                                <asp:BoundField DataField="FromDate" HeaderText="FromDate" HeaderStyle-Width="90px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="ToDate" HeaderText="ToDate" HeaderStyle-Width="90px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="Name" HeaderText="Doctor" HeaderStyle-Width="210px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-HorizontalAlign="Left" />
                                <asp:TemplateField HeaderText="Disc.(%)" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblPanelWiseDisc" runat="server" Text='<%# Eval("PanelWiseDisc") %>' Font-Size="Large" CssClass="ItDoseLblError"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Non-Payable" HeaderStyle-Width="75px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%--Enabled='<%# Util.GetBoolean(Eval("isPayable")) %>'--%>
                                          <asp:CheckBox ID="chkNonPayable" Visible="false" runat="server"  />
                                          <asp:Label ID="lblNonPayable" runat="server" Text='<%# Util.GetString(Eval("isPayable"))=="1"?"Yes":"No" %>'></asp:Label>
                                    </ItemTemplate>

                                </asp:TemplateField>
                                <asp:CommandField HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderText="Remove" HeaderStyle-CssClass="GridViewHeaderStyle" ButtonType="Image"
                                    DeleteText="Delete Item" ShowDeleteButton="true" DeleteImageUrl="~/Images/Delete.gif"
                                    ItemStyle-HorizontalAlign="Center" />

                                <asp:TemplateField Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDoctorID" runat="server" Text='<%# Eval("DoctorID") %>'></asp:Label>
                                        <asp:Label ID="lblItem" runat="server" Text='<%# Eval("ItemID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        <br />
                        <div>
                            <asp:Button AccessKey="r" ID="btnReceipt" OnClick="btnReceipt_Click" runat="server"
                                CssClass="ItDoseButton" Text="Save" CausesValidation="False" TabIndex="8" OnClientClick="return RestrictDoubleEntry(this);"
                                ToolTip="Click To Save Item" />
                        </div>
                    </div>
                </div>
            </asp:Panel>
            <asp:Label ID="lblPatientID" runat="server" Visible="False"></asp:Label>
            <asp:Label ID="lblTransactionNo" runat="server" style="display:none" ClientIDMode="Static"></asp:Label>
            <asp:Label ID="lblCaseTypeID" runat="server" Visible="False"></asp:Label>
            <asp:Label ID="lblPanelID" runat="server" Visible="False"></asp:Label>
            <asp:Label ID="lblReferenceCode" runat="server" Visible="False"></asp:Label>
            <asp:Label ID="lblDoctorID" runat="server" Visible="False"></asp:Label>
            <asp:Label ID="lblPatientType" runat="server" Visible="False"></asp:Label>
            <asp:Label ID="lblPatientType_ID" runat="server" Visible="False"></asp:Label>
            <asp:Label ID="lblRoomID" runat="server" Visible="False"></asp:Label>
            <asp:Label ID="lblMembership" runat="server" Visible="False"></asp:Label>


        </div>
        <asp:Button ID="Button2" runat="server" Text="Button" Style="display: none;" OnClick="Button2_Click" CssClass="ItDoseButton" />
        <asp:Button ID="btnAddDirect" runat="server" Text="Button" OnClick="btnAddDirect_Click"
            Style="display: none;" CssClass="ItDoseButton" />

          <script type="text/html" id="tb_PackageDetail">
        <table class="FixedTables" rules="all" cellspacing="0" border="1" id="tb_PackageData" style="width:100%; border-collapse:collapse">
            <tr id="trHeader">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:130px;">Category</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:130px;">SubCategory</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Item Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Type</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Amount</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Qty</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:10px;">Presc.Amt</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Presc.Qty</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Pending</th>
		</tr>
            <#       
        var dataLength=ResultData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;     
        for(var j=0;j<dataLength;j++)
        {       
        objRow = ResultData[j];
        #>
                <tr <# if(objRow.Ispending==1) {#>
                    style="background-color:lightgreen"
                    <#}else{#>
                    style="background-color:#f14538"
                    <#}#>
                    >                            
                    <td class="GridViewLabItemStyle" style="width:30px;  text-align:center;"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" style="width:200px;" ><#=objRow.Category#></td> 
                    <td class="GridViewLabItemStyle" style="width:200px; " ><#=objRow.Subcategory#></td> 
                    <td class="GridViewLabItemStyle" style="width:100px;  text-align:center;" ><#=objRow.ItemName#></td> 
                    <td class="GridViewLabItemStyle" style="width:80px;  text-align:center;" ><#=objRow.PackageType#></td> 
                    <td class="GridViewLabItemStyle" style="width:80px;  text-align:center;" ><#=objRow.Amount#></td> 
                    <td class="GridViewLabItemStyle" style="width:80px;  text-align:center;" ><#=objRow.Quantity#></td> 
                    <td class="GridViewLabItemStyle" style="width:80px;  text-align:center;" ><#=objRow.UsedAmount#></td> 
                    <td class="GridViewLabItemStyle" style="width:80px;  text-align:center;" ><#=objRow.UsedQuantity#></td> 
                    <td class="GridViewLabItemStyle" style="width:80px;  text-align:center;" ><#=objRow.pending#></td> 
                    
                </tr>           
        <#}#>      
        </table>
    </script>


        <div id="divPackageService"   class="modal fade ">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:900px;height:500px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divPackageService" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Package Services Detail/Status</h4>
				</div>
				<div class="modal-body" style="height:400px">
                    <div class="row" id="divpkg">
						 <div class="col-md-7">
                             <span id="spnPackageID hidden"  ></span>
                            <label class="pull-left patientInfo">Package Name</label>
                             <b class="pull-right">:</b>
						 </div>
                         <div class="col-md-17"> 
                             <b><span id="spnPackageName" class="patientInfo" >
                                 </span></b>

                         </div>
                    </div>
					 <div class="row">
						 <div class="col-md-7">
							   <label class="pull-left">Prescribed  Packages</label>
							   <b class="pull-right">:</b>
						  </div>
						 <div class="col-md-14">
                             <asp:DropDownList ID="ddlPrescribedPackages" runat="server" ClientIDMode="Static"  onchange="getPackageDetail(this.value);"></asp:DropDownList>
						 </div>
                         <div class="col-md-3"></div>
					  </div>
                    <div class="row">
                        <div id="divOutput" style="overflow: scroll;  overflow-x: auto;">
						</div>
                    </div>
				</div>
				  <div class="modal-footer">
                      <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px; background-color:lightgreen" class="circle"></button>
                        <b style="float: left; margin-top: 5px; margin-left: 5px">Pending</b>
                        <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px; background-color:#f14538" class="circle"></button>
                        <b style="float: left; margin-top: 5px; margin-left: 5px">Used</b>
						 <button type="button"  data-dismiss="divPackageService" >Close</button>
				</div>
			</div>
		</div>
	</div>
    </form>
    
</body>
   
</html>
