<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Mortuary_CorpseBillDetails.aspx.cs"
    Inherits="Design_Mortuary_Mortuary_CorpseBillDetails" MaintainScrollPositionOnPostback="true" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Src="~/Design/Controls/StartDate.ascx" TagName="StartDate" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <style type="text/css">
        .header {
            font-weight: bold;
            position: absolute;
            background-color: Green;
        }
    </style>
    <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/framestyle.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
      <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">

        function wopen(url) {
            // Fudge factors for window decoration space.
            // In my tests these work well on all platforms & browsers.
            var win = window.open(url, 'popup', 'width=970, height=480, ' + 'location=no, menubar=no, ' + 'status=no, toolbar=no, scrollbars=yes, resizable=no');
            win.resizeTo(970, 480);
            win.moveTo(10, 100);
            win.focus();
        }

        var _oldColor;

        function SetNewColor(source) {
            _oldColor = source.style.backgroundColor;
            source.style.backgroundColor = 'Green';
        }

        function SetOldColor(source) {
            source.style.backgroundColor = _oldColor;
        }


    </script>
</head>
<body>
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">

        var oldgridcolor;
        function SetMouseOver(element) {
            oldgridcolor = element.style.backgroundColor;
            element.style.backgroundColor = 'aqua';
            element.style.cursor = 'pointer';

        }
        function SetMouseOut(element) {
            element.style.backgroundColor = oldgridcolor;

        }

        $(document).ready(function () {
            $('#ucFromDate').change(function () {
                ChkDate();
            });
            $('#ucToDate').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucFromDate').val() + '",DateTo:"' + $('#ucToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnSearch').attr('disabled', 'disabled');
                        $("#<%=gvDeptBill.ClientID %>").hide();
                        $("#<%=pnlHide.ClientID %>").hide();
                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnSearch').removeAttr('disabled');
                    }
                }
            });

        }
        $(document).ready(function () {
            var MaxLength = 200;
            $("#<% =txtCancelReason.ClientID %>,#<%=txtDiscReason.ClientID %>").bind("cut copy paste", function (event) {
                event.preventDefault();
            });
            $('#<%=txtCancelReason.ClientID%>').bind("keypress", function (e) {
                if (window.event) {
                    keynum = e.keyCode
                }
                else if (e.which) {
                    keynum = e.which
                }
                keychar = String.fromCharCode(keynum)
                if (e.keyCode == 39 || keychar == "'") {
                    return false;
                }
                if ($(this).val().length >= MaxLength) {
                    if (window.event)//IE
                    {
                        e.returnValue = false;
                        return false;
                    }
                    else//Firefox
                    {
                        e.preventDefault();
                        return false;
                    }
                }
            });
        });
        var characterLimit = 200;
        $(document).ready(function () {
            $("#lblremaingCharacters").html(characterLimit - ($("#<%=txtCancelReason.ClientID %>").val().length));
            $("#lblremaingCharacters1").html(characterLimit - ($("#<%=txtDiscReason.ClientID %>").val().length));
            $("#<%=txtCancelReason.ClientID %>").bind("keyup", function () {
                var characterInserted = $(this).val().length;
                if (characterInserted > characterLimit) {
                    $(this).val($(this).val().substr(0, characterLimit));
                }
                var characterRemaining = characterLimit - characterInserted;
                $("#lblremaingCharacters").html(characterRemaining);
            });
            $("#lblremaingCharacters1").html(characterLimit);
            $("#<%=txtDiscReason.ClientID %>").bind("keyup keydown", function () {
                var characterInserted = $(this).val().length;
                if (characterInserted > characterLimit) {
                    $(this).val($(this).val().substr(0, characterLimit));
                }
                var characterRemaining = characterLimit - characterInserted;
                $("#lblremaingCharacters1").html(characterRemaining);
            });
        });
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
        function ValidateDecimalAmtPer() {
            var DigitsAfterDecimal = 2;
            var val = $("#<%=txtEDiscPer.ClientID%>").val();
            var valIndex = val.indexOf(".");
            if (valIndex > "0") {
                if (val.length - (val.indexOf(".") + 1) > DigitsAfterDecimal) {
                    alert("Please Enter Valid Discount Percent, Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                    $("#<%=txtEDiscPer.ClientID%>").val($("#<%=txtEDiscPer.ClientID%>").val().substring(0, ($("#<%=txtEDiscPer.ClientID%>").val().length - 1)))
                    return false;
                }
            }
        }
        function ValidateDecimalAmt() {
            var DigitsAfterDecimal = 2;
            var val = $("#<%=txtEDiscAmt.ClientID%>").val();
            var valIndex = val.indexOf(".");
            if (valIndex > "0") {
                if (val.length - (val.indexOf(".") + 1) > DigitsAfterDecimal) {
                    alert("Please Enter Valid Discount Amount, Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                    $("#<%=txtEDiscAmt.ClientID%>").val($("#<%=txtEDiscAmt.ClientID%>").val().substring(0, ($("#<%=txtEDiscAmt.ClientID%>").val().length - 1)))
                    return false;
                }
            }
        }
        function validateReason() {
            if ($("#<%=txtEDiscPer.ClientID %>").val() > 0 || $("#<%=txtEDiscAmt.ClientID %>").val() > 0) {
                if ($("#<%=txtDiscReason.ClientID %>").val() == '') {
                    $("#lblEditItem").text('Please Enter Discount Reason');
                    return false;
                }
                else {
                    $("#lblEditItem").text('');
                }
            }
            document.getElementById('<%=btnEditSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnEditSave.ClientID%>').value = 'Submitting...';
            __doPostBack('btnEditSave', '');
        }
        function validateDisper() {
            if ($("#<%=txtItemDiscPer.ClientID %>").val() > 100) {
                alert("Please Enter Valid Discount Percent");
                $("#<%=txtItemDiscPer.ClientID %>").val($("#<%=txtItemDiscPer.ClientID %>").val().substring(0, ($("#<%=txtItemDiscPer.ClientID %>").val().length - 1)))
            }
        }
    </script>
    <script type="text/javascript">

        $(document).ready(function () {
            $("#<%=chkItem.ClientID %>").click(function () {
                $("[id$=ChkSelect]").attr('checked', this.checked);

            });
            $("[id$=ChkSelect]").click(function () {
                if ($('[id$=ChkSelect]').length == $('[id$=ChkSelect]:checked').length) {
                    $('[id$=chkItem]').attr("checked", "checked");
                }
                else {
                    $('[id$=chkItem]').removeAttr("checked");
                }
            });
            $('[id$=chkItem]').click(function () {
                if ($("[id$=ChkSelect]").attr('checked') == true && this.checked == false)
                    $("[id$=ChkSelect]").attr('checked', false);

                if (this.checked == true)
                    CheckSelectAll();
            });
            function CheckSelectAll() {
                var flag = true;
                $('[id$=chkItem] input:checkbox').each(function () {
                    if (this.checked == false)
                        flag = false;
                });
                $("[id$=ChkSelect]").attr('checked', flag);
            }
        });
        function ClearRate() {
            $("#txtRate").val('');
            $("#<%=lblmsgpopupRate.ClientID %>").text('');
        }
        function ClearDiscount() {
            $("#<%=txtItemDiscPer.ClientID %>,#<%=txtItemDiscAmt.ClientID %>").val('');
            $("#<%=lblmsgpopupDisc.ClientID %>").text('');
        }
        function clearRejection() {
            $("#<%=txtCancelReason.ClientID %>").val('');
        }
        function ClearFilter() {
            $('#<%=ddlUser.ClientID %>').get(0).selectedIndex = 0;
            $('#<%=ddlSubCategory.ClientID %>').get(0).selectedIndex = 0;
            $('#<%=chkFilter.ClientID %>').removeAttr('checked');
            $("#<%=chkFilterItem.ClientID %> input:checkbox").each(function () {
                $("#<%= chkFilterItem.ClientID %> input:checkbox").removeAttr('checked');
            });
        }
        $(document).ready(function () {
            var DisAmount = $('#txtEDiscAmt').val();
            var DisPercent = $('#txtEDiscPer').val();
            $('#txtEDiscAmt').bind("keyup keydown", function () {

                if ($('#txtEDiscAmt').val() > 0) {
                    $('#txtEDiscPer').val(DisPercent);
                }
                if (parseFloat($('#txtEDiscAmt').val()) > ($('#txtERate').val() * $('#txtEQty').val())) {
                    alert("Discount Amount Can Not Greater then Net Amount");
                    $('#txtEDiscAmt').val(DisAmount);
                    return false;
                }
            });
            $('#txtEDiscPer').bind("keyup keydown", function () {
                if ($('#txtEDiscPer').val() > 0) {
                    $('#txtEDiscAmt').val('0.00');
                }
                if ($('#txtEDiscPer').val() > 100) {
                    alert("Please Enter Valid Discount Percent");
                    $('#txtEDiscPer').val(DisPercent);
                }
            });
        });
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find("mpPackage")) {
                    $find("mpPackage").hide();
                }
                if ($find("mpEdit")) {
                    $find("mpEdit").hide();
                }
                if ($find("mpRate")) {
                    $find("mpRate").hide();
                    $("#<%=txtRate.ClientID %>").val('');
                    $("#<%=lblmsgpopupRate.ClientID %>").text('');
                }
                if ($find("ModalPopupExtender1")) {
                    $find("ModalPopupExtender1").hide();
                    $("#<%=txtItemDiscPer.ClientID %>").val('');
                    $("#<%=lblmsgpopupDisc.ClientID %>").text('');
                }
                if ($find("MdpFilter")) {
                    $find("MdpFilter").hide();
                    $("#<%=ddlSubCategory.ClientID %>").prop("selectedIndex", 0);
                    $("#<%=ddlUser.ClientID %>").prop("selectedIndex", 0);
                    $("#<%=chkFilter.ClientID %>").attr('checked', false);
                    $("#<%=chkFilterItem.ClientID %>").attr('checked', false);
                }

                if ($find("mpItemPackage")) {
                    $find("mpItemPackage").hide();
                    $('#<%=ddlPackage.ClientID%>').prop("selectedIndex", 0);
                }
                if ($find("mpeRejection")) {
                    $find("mpeRejection").hide();
                    $("#<%=txtCancelReason.ClientID %>").val('');
                }
            }
        }
        function validateReject() {
            if (typeof (Page_Validators) == "undefined") return;
            var Reason = document.getElementById("<%=reqReason.ClientID%>");
            var LblName = document.getElementById("<%=lblmsgpopupReject.ClientID%>");
            ValidatorValidate(Reason);
            if (!Reason.isvalid) {
                LblName.innerText = Reason.errormessage;
                return false;
            }
        }
        function validateRate(btn) {
            if (typeof (Page_Validators) == "undefined") return;
            var Rate = document.getElementById("<%=reqRate.ClientID%>");
            var LblName = document.getElementById("<%=lblmsgpopupRate.ClientID%>");
            ValidatorValidate(Rate);
            if (!Rate.isvalid) {
                LblName.innerText = Rate.errormessage;
                return false;
            }
            if (Page_IsValid) {
                document.getElementById('<%=btnRSave.ClientID%>').disabled = true;
                document.getElementById('<%=btnRSave.ClientID%>').value = 'Submitting...';
                __doPostBack('btnRSave', '');
            }
        }
        function validateDiscount() {
            if (typeof (Page_Validators) == "undefined") return;
            var Discount = document.getElementById("<%=reqDiscount.ClientID%>");
            var LblName = document.getElementById("<%=lblmsgpopupDisc.ClientID%>");
            ValidatorValidate(Discount);
            if (!Discount.isvalid) {
                LblName.innerText = Discount.errormessage;
                return false;
            }
            if (Page_IsValid) {
                document.getElementById('<%=btnDiscSave.ClientID%>').disabled = true;
                document.getElementById('<%=btnDiscSave.ClientID%>').value = 'Submitting...';
                __doPostBack('btnDiscSave', '');
            }
        }
        function closeEditItem() {
            if ($find("mpEdit")) {
                $find("mpEdit").hide();
            }
        }

        function closeSetRate() {
            if ($find("mpRate")) {
                $find("mpRate").hide();
                $("#<%=txtRate.ClientID %>").val('');
                $("#<%=lblmsgpopupRate.ClientID %>").text('');
            }
        }

        function closeRejectionReason() {
            if ($find("mpeRejection")) {
                $find("mpeRejection").hide();
                $("#<%=txtCancelReason.ClientID %>").val('');
            }
        }

        function closeSetDiscount() {
            if ($find("ModalPopupExtender1")) {
                $find("ModalPopupExtender1").hide();
                $("#<%=txtItemDiscPer.ClientID %>").val('');
                $("#<%=lblmsgpopupDisc.ClientID %>").text('');
            }
        }

        function closePackage() {
            if ($find("mpItemPackage")) {
                $find("mpItemPackage").hide();
                $('#<%=ddlPackage.ClientID%>').prop("selectedIndex", 0);
            }
        }

        function closeSetFilter() {
            if ($find("MdpFilter")) {
                $find("MdpFilter").hide();
                $("#<%=ddlSubCategory.ClientID %>").prop("selectedIndex", 0);
                $("#<%=ddlUser.ClientID %>").prop("selectedIndex", 0);
                $("#<%=chkFilter.ClientID %>").attr('checked', false);
                $("#<%=chkFilterItem.ClientID %>").attr('checked', false);
            }
        }

        function closeThreshold() {
            if ($find("mpeThreshold")) {
                $find("mpeThreshold").hide();
            }
        }

    </script>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <Ajax:ScriptManager ID="sm1" runat="server" />
            <div class="POuter_Box_Inventory" style="text-align: center;">
                    <b>Corpse Bill Details</b>
                    <br />
             <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
            </div>
            <div class="POuter_Box_Inventory">
                    <table style="width: 100%">
                        <tr>
                            <td style="width: 8%">
                                <asp:LinkButton ID="btnRefresh" runat="server" Text="Refresh Bill" CssClass="ItDoseLinkButton"
                                    OnClick="btnRefresh_Click" />
                            </td>
                            <td style="width: 10%; text-align: right">Gross&nbsp;Bill&nbsp;:&nbsp;
                            </td>
                            <td style="width: 10%; text-align: right">
                                <asp:Label ID="lblGrossBillAmt" runat="server" CssClass="ItDoseLabelSp" />&nbsp;&nbsp;&nbsp;
                            </td>
                            <td style="width: 5%; text-align: right">Discount :&nbsp;
                            </td>
                            <td style="width: 10%; text-align: right">
                                <asp:Label ID="lblBillDiscount" runat="server" CssClass="ItDoseLabelSp" />&nbsp;&nbsp;
                            </td>
                            <td style="width: 10%; text-align: right">Net Amt. :&nbsp;
                            </td>
                            <td style="width: 10%; text-align: right">
                                <asp:Label ID="lblNetAmount" runat="server" CssClass="ItDoseLabelSp" />&nbsp;&nbsp;
                            </td>
                            <td style="width: 6%; text-align: right">Advance :&nbsp;
                            </td>
                            <td style="width: 10%; text-align: right">
                                <asp:Label ID="lblAdvanceAmt" runat="server" CssClass="ItDoseLabelSp" />&nbsp;&nbsp;
                            </td>
                            <td style="width: 10%; text-align: right"></td>
                            <td style="width: 10%; text-align: right"></td>
                        </tr>
                        <tr>
                            <td style="width: 10%">&nbsp;</td>
                            <td style="width: 10%; text-align: right">Tax&nbsp;:&nbsp;</td>
                            <td style="width: 10%; text-align: right">
                                <asp:Label ID="lblTaxPer" runat="server" CssClass="ItDoseLabelSp" />(%)&nbsp;&nbsp;&nbsp;</td>
                            <td style="width: 5%; text-align: right">Total&nbsp;Tax&nbsp;:&nbsp;</td>
                            <td style="width: 10%; text-align: right">
                                <asp:Label ID="lblTotalTax" runat="server" CssClass="ItDoseLabelSp" />&nbsp;&nbsp;</td>
                            <td style="width: 10%; text-align: right">Net&nbsp;Bill&nbsp;Amt.&nbsp;:&nbsp;</td>
                            <td style="width: 10%; text-align: right">
                                <asp:Label ID="lblNetBillAmt" runat="server" CssClass="ItDoseLabelSp" />&nbsp;&nbsp;</td>
                            <td style="width: 6%; text-align: right">Round&nbsp;Off&nbsp;:&nbsp;</td>
                            <td style="width: 10%; text-align: right">
                                <asp:Label ID="lblRoundOff" runat="server" CssClass="ItDoseLabelSp" />&nbsp;&nbsp;                              
                            </td>
                            <td style="width: 10%; text-align: right">Remn.&nbsp;Amt.&nbsp;:&nbsp;</td>
                            <td style="width: 10%; text-align: right">
                                <asp:Label ID="lblBalanceAmt" runat="server" CssClass="ItDoseLabelSp" />&nbsp;&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 8%"></td>
                            <td style="width: 6%; text-align: right">Bill From :&nbsp;
                            </td>
                            <td style="text-align: right">
                                <asp:TextBox ID="ucFromDate" runat="server" Width="82px" ClientIDMode="Static"></asp:TextBox>
                                <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="ucFromDate"
                                    Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>

                            </td>
                            <td style="text-align: right">To :&nbsp;</td>
                            <td colspan="2" style="text-align: left">
                                <asp:TextBox ID="ucToDate" runat="server" Width="82px" ClientIDMode="Static"></asp:TextBox>
                                <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                            </td>
                            <td style="width: 10%">
                                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="ItDoseButton" CausesValidation="False"
                                    OnClick="btnSearch_Click" ClientIDMode="Static" />
                            </td>
                            <td style="width: 6%">
                                <asp:Button ID="btnPrint" runat="server" Text="Report" CssClass="ItDoseButton" CausesValidation="False"
                                    Visible="false" />
                                <cc1:ModalPopupExtender ID="MDPReport" runat="server" CancelControlID="btnCancelReport"
                                    DropShadow="true" TargetControlID="btnPrint" BackgroundCssClass="filterPupupBackground"
                                    PopupControlID="pnlReport" PopupDragHandleControlID="drgReport" />
                            </td>
                            <td style="width: 10%"></td>
                            <td style="width: 7%; text-align: right"><%--&nbsp;&nbsp;Appr.&nbsp;Amt.&nbsp;:&nbsp;--%>
                            </td>
                            <td style="width: 10%; text-align: right">
                                <%--<asp:Label ID="lblApprovalAmt" runat="server" CssClass="ItDoseLabelSp" />&nbsp;&nbsp;--%>
                            </td>
                        </tr>
                    </table>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Department Details
                </div>
                <div  style="text-align: center;">
                    <div>
                        <asp:GridView ID="gvDeptBill" Width="100%" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            OnRowCommand="gvDeptBill_RowCommand" OnRowDataBound="gvDeptBill_RowDataBound">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Department" ItemStyle-HorizontalAlign="Left" HeaderStyle-Width="400px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDisplayName" runat="server" Text='<%#Eval("DisplayName") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Quantity" HeaderStyle-Width="150px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-HorizontalAlign="Right">
                                    <ItemTemplate>
                                        <%#Eval("Qty", "{0:f2}")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Amount" HeaderStyle-Width="150px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-HorizontalAlign="Right">
                                    <ItemTemplate>
                                        <%#Eval("NetAmt","{0:f2}")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="View" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbView" ToolTip="View Item Detail" runat="server" ImageUrl="~/Images/view.GIF"
                                            CausesValidation="false" CommandArgument='<%#Eval("Category")+"#"+Container.DataItemIndex %>'
                                            CommandName="imbView" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Edit" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" Visible="true">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbModify" ToolTip="Modify Item" runat="server" ImageUrl="~/Images/edit.png"
                                            CausesValidation="false" CommandArgument='<%#Eval("Category") %>' CommandName="imbModify"
                                            Visible='<%# Util.GetBoolean(Eval("IsPackage")) %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="View Log" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" Visible="false">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="ImgLogView" ToolTip="Log Item" runat="server" ImageUrl="~/Images/view.GIF"
                                            CausesValidation="false" CommandArgument='<%#Eval("Category")+"#"+Container.DataItemIndex %>'
                                            CommandName="ImgLog" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
            <asp:Panel ID="pnlHide" runat="server">
                <div class="POuter_Box_Inventory" style="text-align: center">
                    <div class="Purchaseheader">
                        <asp:Label ID="lblDept" runat="server" Font-Bold="True" ForeColor="orchid" Font-Size="11pt"></asp:Label>&nbsp;
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; <span style="background-color: orchid">Item Already Prescribed on Same Day</span>
                    </div>
                    <div class="">
                        <label class="labelForTag">
                            Total Amt.:</label>
                        <asp:Label ID="lblFilterAmount" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:CheckBox ID="chkItem" runat="server" Text="Select Items" CssClass="ItDoseCheckbox"
                        AutoPostBack="False" OnCheckedChanged="chkItem_CheckedChanged" Style="display: none;" />
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:Button ID="btnFilter" runat="server" CssClass="ItDoseButton" Text="Filter" Style="display: none;" />
                        &nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:Button ID="btnRate" runat="server" Text="Rate" CssClass="ItDoseButton" Style="display: none;" />
                        &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
                          <asp:Button ID="btnDiscount" runat="server" Text="Discount" CssClass="ItDoseButton" Style="display: none;" />
                        &nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:Button ID="btnReject" runat="server" Text="Reject" CssClass="ItDoseButton" OnClientClick="return confirm('Are you sure ?');"
                        Width="75px" OnClick="btnReject_Click" Style="display: none;" />
                        &nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:Button ID="btnPackage" runat="server" Text="Package" CssClass="ItDoseButton" Style="display: none;" />
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <br />
                        <div style="text-align: center;">
                            <asp:GridView ID="gvItemDetail" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                OnRowCommand="gvItemDetail_RowCommand" OnRowDataBound="gvItemDetail_RowDataBound">
                                <Columns>
                                    <asp:TemplateField Visible="false">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="ChkSelect" runat="server" />
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Item">
                                        <ItemTemplate>
                                            <asp:Label ID="lblItem" runat="Server" Text='<%# String.Concat(Eval("ItemName"),"-(",Eval("subcategoryname"),")") %>' />
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="245px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Date">
                                        <ItemTemplate>
                                            <%# Eval("IssueDate") %>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Rate">
                                        <ItemTemplate>
                                            <asp:Label ID="lblRate" runat="server" Text='<%# Eval("Rate")%>' />
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Quantity">
                                        <ItemTemplate>
                                            <asp:Label ID="lblQty" runat="server" Text='<%# Eval("Quantity")%>' />
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Disc. %">
                                        <ItemTemplate>
                                            <asp:Label ID="lblDiscPer" runat="server" Text='<%#Eval("DiscPer") %>' />
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Disc. &lt;br/&gt;Amt. ">
                                        <ItemTemplate>
                                            <asp:Label ID="lblDiscAmt" runat="server" Text='<%#Eval("DiscAmt") %>' />
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Net Amt. ">
                                        <ItemTemplate>
                                            <%# Eval("Amount")%>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Package">
                                        <ItemTemplate>
                                            <%# Eval("Package")%>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="260px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="User">
                                        <ItemTemplate>
                                            <%#Eval("Name")%>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Disc. Given By">
                                        <ItemTemplate>
                                            <%#Eval("DiscGivenBy")%>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="110px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Edit" Visible="false">
                                        <ItemTemplate>
                                            <%--Visible='<%# Util.GetBoolean(Eval("IsEdit")) %>'    Enabled='<%# Util.GetBoolean(Eval("IsEdit"))%>--%>
                                            <asp:ImageButton ID="imbEdit" runat="server" CausesValidation="false" CommandName="AEdit"
                                                ImageUrl="~/Images/edit.png" CommandArgument='<%# Container.DataItemIndex %>'
                                                Visible='<%# Util.GetBoolean(Eval("IsEdit")) %>' ToolTip="Click to Edit Item" />
                                            <img id="img1" alt="" src="../../Images/edit.png" onclick="wopen('../IPD/SurgeryIPD.aspx?TransactionID=<%# Eval("TransactionID")%>&LedgerTransactionNo=<%# Eval("LtNo")%>&IsSurgery=1');return false"
                                                style='cursor: hand; display: <%# Util.GetBoolean(Eval("IsNPSurgery"))?" ":"none"  %>' />
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Reject" Visible="false">
                                        <ItemTemplate>
                                            <%-- Visible='<%# Util.GetBoolean(Eval("IsReject")) %>'--%>
                                            <asp:ImageButton ID="imbReject" runat="server" CausesValidation="false" CommandName="Reject"
                                                ImageUrl="~/Images/Delete.gif" CommandArgument='<%# Eval("LtNo")+"#"+Eval("IsSurgery") %>'
                                                Enabled='<%# Util.GetBoolean(Eval("IsReject")) %>' ToolTip="Click to Reject Item" />
                                            <asp:Label ID="lblLedTnxNo" runat="server" Text='<%# Eval("LtNo") %>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblIsSurgery" runat="server" Text='<%# Eval("IsSurgery") %>' Visible="false" />
                                            <asp:Label ID="lblItemID" runat="server" Text='<%# Eval("ItemID") %>' Visible="false" />
                                            <asp:Label ID="lblDate" runat="server" Text='<%# Eval("IssueDate") %>' Visible="false" />
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:TemplateField>
                                </Columns>
                                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </asp:Panel>
        </div>
        <asp:Label ID="lblLtdNo" runat="server" Visible="false"></asp:Label>
        <asp:Label ID="lblLTNo" runat="server" Visible="false"></asp:Label>
        <div style="display: none;">
            <asp:Button ID="btnHidden" runat="server" />
        </div>
        <asp:Panel ID="pnlPackage" runat="server" CssClass="pnlOrderItemsFilter" Style="display: none; width: 496px">
            <div class="Purchaseheader" id="drgPackage" runat="server">
                Edit Package
            </div>
            <asp:GridView ID="gvPackage" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                OnRowCommand="gvPackage_RowCommand" Width="494px">
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>
                    <asp:TemplateField ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <asp:CheckBox ID="chkPackage" runat="server" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Package" HeaderStyle-Width="225px" ItemStyle-CssClass="GridViewItemStyle"
                        HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <%# Eval("TypeName") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Date" HeaderStyle-Width="80px" ItemStyle-CssClass="GridViewItemStyle"
                        HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <%#Eval("PDate")%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Amount" HeaderStyle-Width="80px" ItemStyle-CssClass="GridViewItemStyle"
                        HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <asp:TextBox ID="txtAmount" runat="server" Text='<%# Eval("Amount") %>' Width="70px"
                                CssClass="ItDoseTextinputNum" ReadOnly='<%# Util.GetBoolean(Eval("IsEdit")) %> '
                                onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftAmt" runat="server" FilterType="Custom, Numbers"
                                ValidChars="." TargetControlID="txtAmount" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Reject" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                        HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <asp:ImageButton ID="imbReject" runat="server" CausesValidation="false" CommandName="Reject"
                                ImageUrl="~/Images/Delete.gif" CommandArgument='<%#Eval("LedgerTnxID") %>' Enabled='<%# Util.GetBoolean(Eval("IsReject")) %>'
                                OnClientClick="return confirm('Are you sure ?');" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <div class="filterOpDiv">
                <asp:Button ID="btnPackageSave" runat="server" Text="Save" CssClass="ItDoseButton"
                    Width="60px" OnClick="btnPackageSave_Click" />
                &nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnPackageCancel" runat="server" Text="Cancel" CausesValidation="false"
                CssClass="ItDoseButton" Width="60px" />
            </div>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpPackage" runat="server" CancelControlID="btnPackageCancel"
            DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlPackage" PopupDragHandleControlID="drgPackage" BehaviorID="mpPackage" />
        <asp:Panel ID="pnlEdit" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none;"
            Width="520px">
            <div class="Purchaseheader" id="drgEdit" runat="server">
                Edit Item &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;
                &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
                 <em><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor: pointer" onclick="closeEditItem()" />
                     to close</span></em>
            </div>
            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td colspan="4" align="center">
                        <asp:Label ID="lblEditItem" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="labelForTag" style="width: 20%" align="right">Item :&nbsp;
                    </td>
                    <td colspan="3">
                        <asp:Label ID="lblEItem" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="labelForTag" style="width: 20%" align="right">Rate :&nbsp;
                    </td>
                    <td style="width: 30%">
                        <asp:TextBox ID="txtERate" runat="server" CssClass="ItDoseTextinputNum" Width="95px"
                            MaxLength="10" ValidationGroup="Edit" onkeypress="return checkForSecondDecimal(this,event)"
                            ToolTip="Enter Item Rate" TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ft1" runat="server" FilterType="Custom, Numbers"
                            TargetControlID="txtERate" ValidChars="." />
                    </td>
                    <td class="labelForTag" style="width: 20%" align="right">Disc. % :&nbsp;
                    </td>
                    <td style="width: 30%">
                        <asp:TextBox ID="txtEDiscPer" runat="server" CssClass="ItDoseTextinputNum" Width="95px"
                            MaxLength="5" ToolTip="Enter Item Discount %" TabIndex="2" onkeyup="ValidateDecimalAmtPer();"
                            onkeypress="return checkForSecondDecimal(this,event)" ClientIDMode="Static"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Custom, Numbers"
                            TargetControlID="txtEDiscPer" ValidChars="." />
                    </td>
                </tr>
                <tr>
                    <td class="labelForTag" style="width: 20%;" align="right">Qty. :&nbsp;
                    </td>
                    <td style="width: 30%;">
                        <asp:TextBox ID="txtEQty" runat="server" CssClass="ItDoseTextinputNum" Width="95px"
                            ValidationGroup="Edit" onkeypress="return checkForSecondDecimal(this,event)"
                            ToolTip="Enter Item Quantity" TabIndex="3" MaxLength="5" ClientIDMode="Static"></asp:TextBox>
                        <asp:RangeValidator ID="RangeValidator1" ControlToValidate="txtEQty" Type="Double"
                            MinimumValue="1" MaximumValue="100000" runat="server" ErrorMessage="Error" Width="1px"></asp:RangeValidator>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" FilterType="Custom, Numbers"
                            TargetControlID="txtEQty" ValidChars="." />
                    </td>
                    <td class="labelForTag" style="width: 26%;" align="right">Disc. Amt. :&nbsp;
                    </td>
                    <td style="width: 30%;">
                        <asp:TextBox ID="txtEDiscAmt" runat="server" CssClass="ItDoseTextinputNum" MaxLength="10"
                            Width="95px" ToolTip="Enter Item Discount Amount" onkeyup="ValidateDecimalAmt();"
                            TabIndex="4" onkeypress="return checkForSecondDecimal(this,event)" ClientIDMode="Static"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" FilterType="Custom, Numbers"
                            TargetControlID="txtEDiscAmt" ValidChars="." />
                    </td>
                </tr>
                <tr>
                    <td class="labelForTag" style="width: 20%" align="right" valign="top">Disc.&nbsp;Reason :&nbsp;
                    </td>
                    <td colspan="3">
                        <asp:TextBox ID="txtDiscReason" runat="server" ValidationGroup="Edit" Width="378px"
                            Height="60px" TextMode="MultiLine" ToolTip="Enter Item Discount Reason" TabIndex="5"></asp:TextBox>
                        Number of Characters Left:
                    <label id="lblremaingCharacters1" style="background-color: #E2EEF1; color: Red; font-weight: bold;">
                    </label>
                    </td>
                </tr>
                <tr>
                    <td class="labelForTag" style="width: 20%; height: 21px"></td>
                    <td colspan="3" style="height: 21px; text-align: center">
                        <asp:CheckBox ID="chkSetRate" runat="server" Text="Set This Rate For All Room Types"
                            Visible="False" TabIndex="6" />
                    </td>
                </tr>
            </table>
            <div class="filterOpDiv">
                <asp:Button ID="btnEditSave" runat="server" Text="Save" CssClass="ItDoseButton"
                    ValidationGroup="Edit" OnClick="btnEditSave_Click" TabIndex="7" ToolTip="click to Save"
                    OnClientClick="return validateReason();" />
                &nbsp;&nbsp;<asp:Button ID="btnEditCancel" runat="server" Text="Cancel" CausesValidation="false"
                    CssClass="ItDoseButton" TabIndex="8" ToolTip="Click to Cancel" />
            </div>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtERate"
                Display="None" ErrorMessage="Specify Rate" SetFocusOnError="True" ValidationGroup="Edit"></asp:RequiredFieldValidator>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtEQty"
                Display="None" ErrorMessage="Specify Quantity" SetFocusOnError="True" ValidationGroup="Edit"></asp:RequiredFieldValidator>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpEdit" runat="server" CancelControlID="btnEditCancel"
            DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlEdit" PopupDragHandleControlID="drgEdit" BehaviorID="mpEdit" />
        <asp:Panel ID="pnlRate" runat="server" CssClass="pnlItemsFilter" Style="display: none; width: 260px; height: 110px;">
            <div class="Purchaseheader" id="dragHandle" runat="server">
                Set Rate &nbsp;&nbsp;<em><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor: pointer" onclick="closeSetRate()" />
                    to close</span></em>
            </div>
            <table>
                <tr>
                    <td style="text-align: center" colspan="2">
                        <asp:Label ID="lblmsgpopupRate" runat="server" CssClass="ItDoseLblError"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 80px">Rate :&nbsp;
                    </td>
                    <td style="text-align: left; width: 180px">
                        <asp:TextBox ID="txtRate" runat="server" CssClass="ItDoseTextinputNum" Width="100px"
                            ValidationGroup="Rate" MaxLength="10" TabIndex="1" ToolTip="Enter Item Rate"
                            onkeypress="return checkForSecondDecimal(this,event)" ClientIDMode="Static" />
                        <asp:Label ID="Label8" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" FilterType="Custom, Numbers"
                            TargetControlID="txtRate" ValidChars="." />
                        <asp:RequiredFieldValidator ID="reqRate" runat="server" ControlToValidate="txtRate"
                            Display="None" ErrorMessage="Please Enter Rate" SetFocusOnError="True" ValidationGroup="Rate"></asp:RequiredFieldValidator>
                        <br />
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: center">
                        <asp:Button ID="btnRSave" runat="server" Text="Save" CssClass="ItDoseButton" ValidationGroup="Rate"
                            OnClick="btnRSave_Click" OnClientClick="return validateRate(this);" ToolTip="Click to Save Rate"
                            TabIndex="2" />
                        &nbsp;&nbsp;&nbsp;
                    <asp:Button ID="btnRCancel" runat="server" Text="Cancel" CausesValidation="false"
                        CssClass="ItDoseButton" ToolTip="Click to Cancel Rate" TabIndex="3" />
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpRate" runat="server" CancelControlID="btnRCancel" DropShadow="true"
            TargetControlID="btnRate" BackgroundCssClass="filterPupupBackground" PopupControlID="pnlRate"
            PopupDragHandleControlID="dragHandle" BehaviorID="mpRate" OnCancelScript="ClearRate();" />
        <asp:Panel ID="pnlRejection" runat="server" CssClass="pnlItemsFilter" Style="display: none;"
            Width="480px" Height="180px">
            <div class="Purchaseheader" id="Div1" runat="server">
                Rejection Reason &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
            &nbsp; &nbsp;  <em><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor: pointer" onclick="closeRejectionReason()" />
                to close</span></em>
            </div>
            <table>
                <tr>
                    <td colspan="2" style="text-align: center">
                        <asp:Label ID="lblmsgpopupReject" runat="server" CssClass="ItDoseLblError"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="vertical-align: top">Reason :&nbsp;
                    </td>
                    <td>
                        <asp:TextBox ID="txtCancelReason" runat="server" Width="370px" ValidationGroup="Reject"
                            MaxLength="50" ToolTip="Enter Reject Reason" TabIndex="1" TextMode="MultiLine"
                            Height="80px" />
                        <asp:Label ID="Label5" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        <br />
                        Number of Characters Left:
                    <label id="lblremaingCharacters" style="background-color: #E2EEF1; color: Red; font-weight: bold;">
                    </label>
                        <asp:RequiredFieldValidator ID="reqReason" runat="server" ControlToValidate="txtCancelReason"
                            Display="None" ErrorMessage="Please Enter Reason" SetFocusOnError="True" ValidationGroup="Reject"></asp:RequiredFieldValidator>
                        <br />
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: center">
                        <asp:Button ID="btnOKRejection" runat="server" Text="Reject" CssClass="ItDoseButton"
                            ValidationGroup="Reject" OnClientClick="return validateReject();" OnClick="btnOKRejection_Click"
                            TabIndex="2" ToolTip="Click to Reject" />
                        &nbsp; &nbsp;&nbsp;
                    <asp:Button ID="btnCancelRejection" runat="server" Text="Cancel" CausesValidation="false"
                        CssClass="ItDoseButton" TabIndex="3" ToolTip="Click to Cancel" />
                        <asp:Label ID="lblIsSurgery" runat="server" Visible="false"></asp:Label>
                        <asp:Label ID="lblLedTnxNo" runat="server" Visible="false"></asp:Label>
                        <asp:Label ID="lblLedTnxID" runat="server" Visible="false"></asp:Label>
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpeRejection" runat="server" CancelControlID="btnCancelRejection"
            DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlRejection" BehaviorID="mpeRejection" PopupDragHandleControlID="dragHandle"
            OnCancelScript="clearRejection();" />
        <asp:Panel ID="pnlDiscount" runat="server" CssClass="pnlItemsFilter" Style="display: none;"
            Width="300px" Height="110px">
            <div class="Purchaseheader" id="dvDiscount" runat="server">
                Set Discount&nbsp;&nbsp;&nbsp;&nbsp;<em><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor: pointer" onclick="closeSetDiscount()" />
                    to close</span></em>
            </div>
            <table style="width: 100%">
                <tr>
                    <td style="text-align: center; width: 100%" colspan="2">
                        <asp:Label ID="lblmsgpopupDisc" runat="server" CssClass="ItDoseLblError"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 80px">Disc.(%)&nbsp;:&nbsp;
                    </td>
                    <td>
                        <asp:TextBox ID="txtItemDiscPer" AutoCompleteType="Disabled" runat="server" CssClass="ItDoseTextinputNum"
                            Width="100px" TabIndex="1" ToolTip="Enter Discount %" onkeypress="return checkForSecondDecimal(this,event)"
                            onkeyup="validateDisper();" />
                        <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" FilterType="Custom, Numbers"
                            TargetControlID="txtItemDiscPer" ValidChars="." />
                        <asp:RequiredFieldValidator ID="reqDiscount" runat="server" ControlToValidate="txtItemDiscPer"
                            Display="None" ErrorMessage="Please Enter Discount %" SetFocusOnError="True"
                            ValidationGroup="Disc"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr style="display: none">
                    <td style="text-align: right">Disc. Amt. :&nbsp;
                    </td>
                    <td>
                        <asp:TextBox ID="txtItemDiscAmt" runat="server" CssClass="ItDoseTextinputNum" Width="95px"
                            ValidationGroup="Discount" TabIndex="2" ToolTip="Enter Discount Amount" onkeypress="return checkForSecondDecimal(this,event)" />
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender6" runat="server" FilterType="Custom, Numbers"
                            TargetControlID="txtItemDiscAmt" ValidChars="." />
                    </td>
                    <td>
                        <label class="labelForTax" style="width: 74px">
                        </label>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: center">
                        <asp:Button ID="btnDiscSave" runat="server" Text="Save" CssClass="ItDoseButton" OnClientClick="return validateDiscount();"
                            OnClick="btnDiscSave_Click" TabIndex="3" ToolTip="Click to Save" ValidationGroup="Disc" />
                        &nbsp;&nbsp;&nbsp;
                    <asp:Button ID="btnDiscCancel" runat="server" Text="Cancel" CausesValidation="false"
                        CssClass="ItDoseButton" TabIndex="4" ToolTip="Click to Cancel" />
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <asp:Panel ID="pnlItemPackage" runat="server" CssClass="pnlOrderItemsFilter" Style="display: none;"
            Width="480px">
            <div class="Purchaseheader" id="drgPkgItem" runat="server">
                Package&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                &nbsp;&nbsp;&nbsp;&nbsp; <em><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor: pointer" onclick="closePackage()" />
                    to close</span></em>
            </div>
            <div class="content">
                <label class="labelForTag">
                    Package :&nbsp;
                </label>
                <asp:DropDownList ID="ddlPackage" ToolTip="Select Package" runat="server" Width="375px">
                </asp:DropDownList>
            </div>
            <div class="filterOpDiv">
                <asp:Button ID="btnItemPkgSave" runat="server" Text="Save" CssClass="ItDoseButton"
                    Width="65px" OnClick="btnItemPkgSave_Click" />
                &nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnItemPkgCancel" runat="server" Text="Cancel" CausesValidation="false"
                CssClass="ItDoseButton" Width="65px" />
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlFilter" runat="server" CssClass="pnlOrderItemsFilter" Style="display: none;"
            Width="519px">
            <div class="Purchaseheader" id="drgFilter" runat="server">
                Set Filter&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
                &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;
             <em><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor: pointer" onclick="closeSetFilter()" />
                 to close</span></em>
            </div>
            <div class="content">
                <label class="labelForTag">
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; User :</label>&nbsp;<asp:DropDownList ID="ddlUser"
                        runat="server" CssClass="ItDoseDropdownbox" Width="350px" />
                <br />
                <Ajax:UpdatePanel ID="upFilter" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <label class="labelForTag">
                            Sub Dept :</label>
                        <asp:DropDownList ID="ddlSubCategory" runat="server" Width="350px" AutoPostBack="True"
                            CssClass="ItDoseDropdownbox" OnSelectedIndexChanged="ddlSubCategory_SelectedIndexChanged" />
                        <br />
                        <asp:CheckBox ID="chkFilter" runat="server" CssClass="ItDoseCheckbox" AutoPostBack="true"
                            Text="Select" OnCheckedChanged="chkFilter_CheckedChanged" />
                        <br />
                        <div style="max-height: 200px; overflow: auto">
                            <asp:CheckBoxList ID="chkFilterItem" runat="server" RepeatColumns="2" RepeatDirection="Horizontal"
                                CssClass="ItDoseCheckboxlist" Font-Size="8pt" />
                        </div>
                    </ContentTemplate>
                </Ajax:UpdatePanel>
            </div>
            <div class="filterOpDiv">
                <asp:Button ID="btnApplyFilter" runat="server" Text="Filter" CssClass="ItDoseButton"
                    OnClick="btnApplyFilter_Click" />
                &nbsp;&nbsp;&nbsp;<asp:Button ID="btnFCancel" runat="server" CausesValidation="false"
                    CssClass="ItDoseButton" Text="Cancel" />
                &nbsp;
            </div>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="MdpFilter" runat="server" CancelControlID="btnFCancel"
            DropShadow="true" TargetControlID="btnFilter" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlFilter" PopupDragHandleControlID="drgFilter" BehaviorID="MdpFilter"
            OnCancelScript="ClearFilter();" />
        <asp:Panel ID="pnlReport" runat="server" CssClass="pnlItemsFilter" Style="display: none;">
            <div class="Purchaseheader" id="drgReport" runat="server">
                Select Report Type
            </div>
            <div class="content">
                <asp:RadioButtonList ID="rdbReport" runat="server" RepeatDirection="Horizontal" CssClass="ItDoseRadiobuttonlist">
                    <asp:ListItem Text="Summary" Value="1" Selected="true"></asp:ListItem>
                    <asp:ListItem Text="Detail" Value="2"></asp:ListItem>
                </asp:RadioButtonList>
            </div>
            <div class="filterOpDiv">
                <asp:Button ID="btnReport" runat="server" Text="Report" CssClass="ItDoseButton" Width="65px"
                    OnClick="btnReport_Click" />
                &nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnCancelReport" runat="server" Text="Cancel" CausesValidation="false"
                CssClass="ItDoseButton" Width="65px" />
            </div>
        </asp:Panel>
        <asp:Panel ID="PnlLog" runat="server" CssClass="pnlOrderItemsFilter" Style="display: none;">
            <div class="POuter_Box_Inventory">
                <div class="content" style="text-align: center;">
                    <div id="colorindication" runat="server">
                        <table width="50%">
                            <tr>
                                <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: #90EE90;">&nbsp;&nbsp;&nbsp;&nbsp;
                                </td>
                                <td>Discount Item
                                </td>
                                <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: #ff99cc;">&nbsp;&nbsp;&nbsp;&nbsp;
                                </td>
                                <td>Updated Item
                                </td>
                                <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: #ff99cd;">&nbsp;&nbsp;&nbsp;&nbsp;
                                </td>
                                <td>Rejected Item
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            <div class="Purchaseheader" id="DivLog" runat="server" style="width: 900px;">
                Log Details
            </div>
            <div class="content" style="text-align: center;">
                <asp:GridView ID="grdLog" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                    OnRowDataBound="grdLog_RowDataBound">
                    <Columns>
                        <asp:TemplateField HeaderText="LederTnxID" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblLedgerTnxID" runat="server" Text=' <%#Eval("LedgerTnxID") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="110px" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="Status" HeaderText="Status" />
                        <%--  <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                            <%# Eval("Status") %>
                             <asp:Label ID="lblStatus" runat="Server" Text='<%# Eval("Status") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Center" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                        </asp:TemplateField>--%>
                        <asp:BoundField DataField="subcategoryname" HeaderText="subcategoryname" />
                        <asp:BoundField DataField="itemname" HeaderText="itemname" />
                        <%-- <asp:TemplateField HeaderText="Item">
                            <ItemTemplate>
                            <%# String.Concat(Eval("itemname"),"-(",Eval("subcategoryname"),")") %>
                               <asp:Label ID="lblItem" runat="Server" Text='<%# String.Concat(Eval("itemname"),"-(",Eval("subcategoryname"),")") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                        </asp:TemplateField>--%>
                        <asp:BoundField DataField="VerifiedDate" HeaderText="VerifiedDate" />
                        <%--   <asp:TemplateField HeaderText="Entry Date">
                            <ItemTemplate>
                             <%# Eval("VerifiedDate")%>
                            <asp:Label ID="lblVerifiedDate" runat="server" Text='<%# Eval("VerifiedDate")%>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" Width="200px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        --%>
                        <asp:BoundField DataField="Rate" HeaderText="Rate" />
                        <%-- <asp:TemplateField HeaderText="Item Rate">
                            <ItemTemplate>
                            <%# Eval("Rate","{0:f1}")%>
                             <asp:Label ID="lblRate" runat="server" Text='<%# Eval("Rate","{0:f1}")%>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                        </asp:TemplateField>--%>
                        <asp:BoundField DataField="Quantity" HeaderText="Quantity" />
                        <%--     <asp:TemplateField HeaderText="Qty">
                            <ItemTemplate>
                            <%# Eval("Quantity")%>
                             <asp:Label ID="lblQty" runat="server" Text='<%# Eval("Quantity")%>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                        </asp:TemplateField>--%>
                        <asp:BoundField DataField="DiscountPercentage" HeaderText="Disc%" />
                        <%--  <asp:TemplateField HeaderText="Disc%">
                            <ItemTemplate>
                            <%#Eval("DiscountPercentage","{0:f1}") %>
                             <asp:Label ID="lblDiscPer" runat="server" Text='<%#Eval("DiscountPercentage","{0:f1}") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                        </asp:TemplateField>--%>
                        <asp:BoundField DataField="DiscAmt" HeaderText="DiscAmt" />
                        <%-- <asp:TemplateField HeaderText="Disc&lt;br/&gt;Amt">
                            <ItemTemplate>
                            <%#Eval("DiscAmt","{0:f1}") %>
                                <asp:Label ID="lblDiscAmt" runat="server" Text='<%#Eval("DiscAmt","{0:f1}") %>' />                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>--%>
                        <asp:BoundField DataField="Amount" HeaderText="Amount" />
                        <%-- <asp:TemplateField HeaderText="Net Amt">
                            <ItemTemplate>
                                <%# Eval("Amount", "{0:f1}")%>
                                
                             <asp:Label ID="lblAmount" runat="server" Text='<%# Eval("Amount", "{0:f1}")%>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                        </asp:TemplateField>--%>
                        <asp:BoundField DataField="User_ID" HeaderText="User_ID" />
                        <%--   <asp:TemplateField HeaderText="User">
                            <ItemTemplate>
                                <%#Eval("User_ID")%>
                               <asp:Label ID="lblUser_ID" runat="server" Text='<%#Eval("User_ID")%>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="110px" />
                        </asp:TemplateField>--%>
                        <asp:BoundField DataField="DiscountReason" HeaderText="DiscountReason" />
                        <%--   <asp:TemplateField HeaderText="Discount Reason">
                            <ItemTemplate>
                              <%#Eval("DiscountReason")%>
                              <asp:Label ID="lblDiscountReason" runat="server" Text='<%#Eval("DiscountReason")%>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="110px" />
                        </asp:TemplateField>--%>
                        <asp:BoundField DataField="DiscUserID" HeaderText="DiscUserID" />
                        <%-- <asp:TemplateField HeaderText="DiscGivenBy">
                            <ItemTemplate>
                               <%#Eval("DiscUserID")%>
                                 <asp:Label ID="lblDiscUserID" runat="server" Text='<%#Eval("DiscUserID")%>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="110px" />
                        </asp:TemplateField>--%>
                        <asp:BoundField DataField="CancelDateTime" HeaderText="CancelDateTime" />
                        <%--  <asp:TemplateField HeaderText="Cancel Date">
                            <ItemTemplate>
                             <%#Eval("CancelDateTime")%>
                           <asp:Label ID="lblCancelDateTime" runat="server" Text='<%#Eval("CancelDateTime")%>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="110px" />
                        </asp:TemplateField>--%>
                        <asp:BoundField DataField="CancelReason" HeaderText="CancelReason" />
                        <%--       <asp:TemplateField HeaderText="Cancel Reason">
                            <ItemTemplate>
                            <%#Eval("CancelReason")%>
                            <asp:Label ID="lblCancelReason" runat="server" Text='<%#Eval("CancelReason")%>' />
                               
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="110px" />
                        </asp:TemplateField>--%>
                        <asp:BoundField DataField="CancelUserId" HeaderText="CancelUserId" />
                        <%--     <asp:TemplateField HeaderText="Cancel By">
                            <ItemTemplate>
                            <%#Eval("CancelUserId")%>
                         <asp:Label ID="lblCancelUserId" runat="server" Text='<%#Eval("CancelUserId")%>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="110px" />
                        </asp:TemplateField>--%>
                        <asp:BoundField DataField="Updateddate" HeaderText="Update Date" />
                        <%-- <asp:TemplateField HeaderText="Last Update Date">
                            <ItemTemplate>
                            <%#Eval("Updatedate")%>
                            <asp:Label ID="lblUpdatedate" runat="server" Text='<%#Eval("Updatedate")%>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="110px" />
                        </asp:TemplateField>--%>
                        <asp:BoundField DataField="LastUpdatedBy" HeaderText="LastUpdatedBy" />
                        <asp:TemplateField HeaderText="Update By" Visible="false">
                            <ItemTemplate>
                                <%#Eval("LastUpdatedBy") %>
                                <asp:Label ID="lblUpdate" runat="server" Text=' <%#Eval("LastUpdatedBy") %>' />
                                <asp:Label ID="lblReject" runat="server" Text=' <%#Eval("CancelUserId") %>' Visible="false" />
                                <asp:Label ID="lblDiscount" runat="server" Text='<%#Eval("DiscUserID")%>' Visible="false" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="110px" />
                        </asp:TemplateField>
                    </Columns>
                    <%--<HeaderStyle CssClass="header" Height="20px" />--%>
                </asp:GridView>
            </div>
            <div class="filterOpDiv" style="width: 900px;">
                <div class="content" style="text-align: center;">
                    <asp:Button ID="btnLogCancel" runat="server" Text="Cancel" CausesValidation="false"
                        CssClass="ItDoseButton" Width="65px" />
                </div>
            </div>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="MDPLog" runat="server" TargetControlID="btnHidden" DropShadow="true"
            BackgroundCssClass="filterPupupBackground" PopupControlID="PnlLog" CancelControlID="btnLogCancel"
            PopupDragHandleControlID="DivLog" X="24" Y="20" />
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="True"
            ShowSummary="False" ValidationGroup="Edit" />
    </form>
</body>
</html>
