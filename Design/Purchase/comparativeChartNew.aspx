<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="ComparativeChartNew.aspx.cs" EnableEventValidation="false" Inherits="Design_Purchase_ComparativeChartNew" %>

<%@ Register Src="~/Design/Controls/StartDate.ascx" TagName="StartDate" TagPrefix="uc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script  src="../../Scripts/Message.js" type="text/javascript"></script>
        rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox-1.3.4.pack.js"></script>
    <link rel="Stylesheet" href="../../Scripts/fancybox/jquery.fancybox-1.3.4.css" type="text/css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.mousewheel-3.0.4.pack.js"></script>
    <script type="text/javascript" >
        var _oldColor;
        function SetNewColor(source) {
            _oldColor = source.style.backgroundColor;
            source.style.backgroundColor = 'Green';
        }
        function SetOldColor(source) {
            source.style.backgroundColor = _oldColor;
        }
        var _oldColornew;
        function SetNewColorNew(source) {
            _oldColornew = source.style.backgroundColor;
            source.style.backgroundColor = 'Silver';
        }
        function SetOldColorNew(source) {
            source.style.backgroundColor = _oldColornew;
        }
        var _oldColorp;
        function SetNewColorP(source) {
            _oldColorp = source.style.backgroundColor;
            source.style.backgroundColor = 'Yellow';
        }
        function SetOldColorP(source) {
            source.style.backgroundColor = _oldColorp;
        }
        
        $(document).ready(function () {
            $('#DateFrom').change(function () {
                ChkDate();
            });

            $('#DateTo').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#DateFrom').val() + '",DateTo:"' + $('#DateTo').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        DisplayMsg('MM09', '<%=lblmsg.ClientID %>');
                        $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');
                    }
                    else {
                        $('#<%=lblmsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');
                    }
                }
            });
        }
    </script>
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
        function validatetax() {
            $("input[id*=txtPer]").bind("blur keyup keydown", function () {
                if (($(this).closest("tr").find("input[id*=txtPer]").val().charAt(0) == ".")) {
                    $(this).closest("tr").find("input[id*=txtPer]").val('');
                }
                var tax = $(this).closest("tr").find("input[id*=txtPer]").val();
                if (Number(tax) > 100) {
                    $(this).closest("tr").find("input[id*=txtPer]").val('');
                    alert('Invalid Discount');
                }
            });
            return true;
        }
       
        
    </script>
    <script type="text/javascript">
        var url = "";
        function showtRecord(ModelNumber, DeliveryTime, PaymentPattern, AMC, OperationalCost, SilentFeatures, AdditionalFeatures, ItemName, Vendor, RefNo, Date, Rate, Discount, TaxPer, CostPrice, TotalCost, Specification, UploadStatus,URL) {
            $("#ItemName").html(ItemName);
            $("#ModalNumber").html(ModelNumber);
            $("#DeliveryTime").html(DeliveryTime);
            $("#PaymentPattern").html(PaymentPattern);
            $("#AMC").html(AMC);
            $("#OperationalCost").html(OperationalCost);
            $("#SilentFeatures").html(SilentFeatures);
            $("#AdditionalFeatures").html(AdditionalFeatures);
            $("#QuotationNo").html(RefNo);
            $("#Date").html(Date);
            $("#RateUnit").html(Rate);
            $("#Discount").html(Discount);
            $("#TaxPer").html(TaxPer);
            $("#CostPrice").html(CostPrice);
            $("#Specification").html(Specification);
            $("#UrlPath").html(URL);
            
             url = location.protocol + "//" + location.host + "/his/QuotationDocument/" + URL;
          
            $("#Path").attr(url);
           
            if (UploadStatus != "0") {
                $("#tdDoc").show();
                
            }
            else {
                $("#tdDoc").hide();
                
            }
            $("#dialog").dialog({
                title: Vendor,
                width: 720,
                modal: true,
                draggable: true,
                resizable: false,
                show: {
                    effect: "blind",
                    duration: 400
                },
                hide: {
                    effect: "explode",
                    duration: 300
                }

            });
            return false;
        }
       
        $(document).ready(function () {

            $("#imgUrlPath").click(function () {
                window.open(url);
            });
        });

        
       
    </script>
    <script type="text/javascript">
        $(document).ready(function () {

            var url;
            var dWidth;
            $(".fancybox").click(function () {
                url = $(this).attr("href");
                var reUrl = window.location.href;
                if (screen.width > 1024) {
                    dWidth = 850;
                }
                else {
                    dWidth = 750;
                }

                $("#fancybox-close").click(function () {
                    $(".imgVendor").click();
                   
                });
                


            });
            $(".fancybox").fancybox({
                'background': 'none',
                'hideOnOverlayClick': true,
                'overlayColor': 'gray',
                'width': dWidth,
                'height': '90%',
                'autoScale': false,
                'autoDimensions': false,
                'transitionIn': 'elastic',
                'transitionOut': 'elastic',
                'speedIn': 600,
                'speedOut': 600,
                'href': url,
                'type': 'iframe',
                'overlayShow': true,
                'opacity': true,
                'centerOnScroll': true,
                'onComplete': function () {
                    if (screen.width > 1024) {
                        $('#fancybox-content').removeAttr('style').css({ 'height': $(window).height() - 100, 'margin': '0 auto', 'width': 850 });
                        $('#fancybox-wrap').removeAttr('style').css({ 'height': $(window).height() - 100, 'margin': '0 auto', 'width': 850 }).show();
                        $.fancybox.resize();
                        $.fancybox.center();
                    }
                    else {
                        $('#fancybox-content').removeAttr('style').css({ 'height': $(window).height() - 100, 'margin': '0 auto', 'width': 850 });
                        $('#fancybox-wrap').removeAttr('style').css({ 'height': $(window).height() - 100, 'margin': '0 auto', 'width': 850 }).show();
                        $.fancybox.resize();
                        $.fancybox.center();
                    }

                }
            });
        });
    </script>
    <div>
        <div>
            <div id="Pbody_box_inventory">
                <Ajax:ScriptManager ID="ScriptManager2" runat="server">
                        </Ajax:ScriptManager>
                <div class="POuter_Box_Inventory" style="text-align: center;">
                    <b>
                        
                        Comparative Chart</b>&nbsp;<br />
                    <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError" />
                </div>
                <div class="POuter_Box_Inventory">

                    <table cellpadding="0" cellspacing="0" style="width: 100%">
                        <tr>
                            <td style="width: 25%; text-align: right; ">Purchase Request No. :&nbsp;
                            </td>
                            <td style="width: 20%; text-align: left; ">
                                <asp:TextBox ID="txtPr" runat="server" Width="165px"> </asp:TextBox>

                            </td>
                            <td style="width: 25%; text-align: right; ">Department :&nbsp;
                            </td>
                            <td style="width: 20%; text-align: left; height: 20px;">
                                <asp:DropDownList ID="ddlDept" runat="server" Width="170px">
                                </asp:DropDownList>
                            </td>
                            <td style="width: 20%; text-align: left; ">&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 15%; text-align: right;">Store Type :&nbsp;
                            </td>
                            <td style="width: 20%; text-align: left;">
                                <asp:DropDownList ID="ddlStore" runat="server" Width="170px"
                                    AutoPostBack="true" OnSelectedIndexChanged="ddlStore_SelectedIndexChanged">
                                </asp:DropDownList>
                            </td>
                            <td style="width: 15%; text-align: right;">Company :&nbsp;
                            </td>
                            <td style="width: 20%; text-align: left;">
                                <asp:DropDownList ID="ddlCompany" runat="server" Width="170px">
                                </asp:DropDownList>
                                <br />
                            </td>
                            <td style="width: 20%; text-align: left;"></td>
                        </tr>
                        <tr>
                            <td style="text-align: right">Group Head :&nbsp;
                            </td>
                            <td style="text-align: left;">
                                <asp:DropDownList ID="ddlGroup" runat="server" AutoPostBack="True"
                                    Width="170px" OnSelectedIndexChanged="ddlGroup_SelectedIndexChanged">
                                </asp:DropDownList>
                            </td>
                            <td style="width: 15%; text-align: right;">
                            </td>
                            <td style="width: 20%; text-align: left;">
                               
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right;">From Date :&nbsp;
                            </td>
                            <td style="text-align: left;">
                                <asp:TextBox ID="DateFrom" runat="server" Width="100px" ClientIDMode="Static"></asp:TextBox>
                                <cc1:CalendarExtender ID="calDateFrom" runat="server" Format="dd-MMM-yyyy" TargetControlID="DateFrom">
                                </cc1:CalendarExtender>
                            </td>
                            <td  style="text-align: right;">To Date :&nbsp;
                            </td>
                            <td style="text-align: left;">
                                <asp:TextBox ID="DateTo" runat="server" Width="100px" ClientIDMode="Static"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy"
                                    TargetControlID="DateTo">
                                </cc1:CalendarExtender>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">Item :&nbsp;
                            </td>
                            <td colspan="3" style="text-align: left">
                                <asp:DropDownList ID="ddlItem" runat="server" Width="450px">
                                </asp:DropDownList>
                                &nbsp;&nbsp;<br />
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 15%; text-align: right">Vendor :&nbsp;
                            </td>
                            <td colspan="3" style="text-align: left">
                                <asp:DropDownList ID="ddlVendor" runat="server" Width="450px">
                                </asp:DropDownList>
                            </td>
                            <td style="width: 20%; text-align: left"></td>
                        </tr>
                        <tr>
                            <td style="width: 15%; text-align: right; vertical-align:top" >Quotation :&nbsp;
                            </td>
                            <td style="width: 20%; text-align: left;vertical-align:top">
                                <asp:RadioButtonList ID="rbtn" runat="server" RepeatDirection="horizontal" >
                                    <asp:ListItem>Yes</asp:ListItem>
                                    <asp:ListItem>No</asp:ListItem>
                                    <asp:ListItem  Selected="True">All</asp:ListItem>
                                </asp:RadioButtonList>
                                &nbsp;
                            </td>
                            <td style="width: 15%; text-align: left">&nbsp;
                            </td>
                            <td style="width: 20%; text-align: left">
                                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="ItDoseButton" OnClick="btnSearch_Click" />
                            </td>
                            <td style="width: 20%; text-align: left"></td>
                        </tr>
                        <tr>
                            <td style="width: 15%; text-align: right;" valign="top"></td>
                            <td style="width: 20%; text-align: right">
                                <asp:Button ID="btnSet" runat="server" Width="20px" Height="20px" BackColor="LightGreen"
                                    BorderStyle="Solid" BorderColor="Black" CssClass="ItDoseButton11" />
                                &nbsp; 
                                         Set
                            </td>
                            <td style="width: 15%; text-align: center">
                                <asp:Button ID="btnNSet" runat="server" Width="20px" Height="20px" BackColor="Pink"
                                    BorderStyle="Solid" BorderColor="Black" CssClass="ItDoseButton11" />
                                &nbsp; 
                                        Not Set
                            </td>
                            <td style="width: 20%; text-align: left"></td>
                            <td style="width: 20%; text-align: left"></td>
                        </tr>
                    </table>

                </div>
                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        Purchase Request
                    </div>
                    <div class="content">
                        <div style="text-align: center;">

                            <asp:Panel ID="pnlgv" runat="server" Width="960px">
                                <asp:Repeater ID="rptpr" runat="server" OnItemCommand="rptpr_ItemCommand">
                                    <HeaderTemplate>
                                        <table class="GridViewStyle" cellspacing="0" style="border-collapse: collapse;">
                                            <tr style="text-align: center; background-color: #afeeee;">
                                                <th class="GridViewHeaderStyle" scope="col">&nbsp;
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col">S.No.
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col">Request No.
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col">Dept. Raised
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col">Raised Date
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col">Raised User
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col">Store Type
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col">Narration
                                                </th>
                                            </tr>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr style="text-align: center; background-color: #afeeee;">
                                            <td class="GridViewItemStyle" style="width: 30px; text-align: left;">
                                                <asp:ImageButton ID="imbVendor" runat="server" AlternateText="Show" ImageUrl="~/Images/plus.png"
                                                    CausesValidation="false"    Class="imgVendor" CommandArgument='<%# Eval("PurchaseRequestNo") %>' />
                                            </td>
                                            <td class="GridViewItemStyle" style="width: 30px;">
                                                <%# Container.ItemIndex+1 %>
                                            </td>
                                            <td class="GridViewItemStyle" style="width: 200px; text-align: left;">
                                                <b>
                                                    <%# Eval("PurchaseRequestNo")%></b>
                                            </td>
                                            <td class="GridViewItemStyle" style="width: 200px;">
                                                <%# Eval("DeptRaised")%>
                                            </td>
                                            <td class="GridViewItemStyle" style="width: 120px;">
                                                <%# Eval("RaisedDate")%>
                                            </td>
                                            <td class="GridViewItemStyle" style="width: 230px; text-align: left;">
                                                <b>
                                                    <%# Eval("Name")%></b>
                                            </td>
                                            <td class="GridViewItemStyle" style="width: 150px;">
                                                <%# Eval("StoreType")%>
                                            </td>
                                            <td class="GridViewItemStyle" style="width: 300px;">
                                                <%# Eval("Subject")%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="8" style="padding-left: 5px">
                                                <asp:Repeater ID="rptitems" OnItemDataBound="BindLastVendor" runat="server">
                                                    <HeaderTemplate>
                                                        <table cellpadding="0" cellspacing="0">
                                                            <tr style="text-align: center; color: #387C44; background-color: #fafad2;">
                                                                <th scope="col">&nbsp;
                                                                </th>
                                                                <th scope="col">S.No.
                                                                </th>
                                                                <th scope="col">Item Name
                                                                </th>
                                                                <th scope="col">Company
                                                                </th>
                                                                <th scope="col" style="text-align: center; vertical-align: middle;">
                                                                    <asp:Label ID="idhead" runat="server" Text="Rate#DiscAmt#TaxPer#UnitPrice<br>#Qty#Date#LastVendor"
                                                                        Width="250px" />
                                                                </th>
                                                                <th scope="col">In Hand
                                                                </th>
                                                                <th scope="col">Requested Qty.
                                                                </th>
                                                                <th scope="col">Approved Qty.
                                                                </th>
                                                                <th scope="col"></th>
                                                            </tr>
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <tr style="text-align: center; background-color: #fafad2;">
                                                            <td style="width: 30px;">
                                                                <asp:ImageButton ID="imbVendor" runat="server" AlternateText="Show" ImageUrl="~/Images/plus.png"
                                                                    CausesValidation="false" CommandArgument='<%# Eval("ItemID")+"#"+ Eval("PurchaseRequisitionNo")+"#"+Eval("ApprovedQty") %>'
                                                                    OnClick="BindVender" />
                                                            </td>
                                                            <td style="width: 50px;">
                                                                <%# Container.ItemIndex+1 %>
                                                            </td>
                                                            <td style="width: 400px;" align="left">
                                                                <%# Eval("ItemName")%>
                                                            </td>
                                                            <td style="width: 60px;" align="left">
                                                                <%# Eval("Manufacturer")%>
                                                            </td>
                                                            <td style="width: 250px;">
                                                                <asp:Label ID="lblLastVendor" runat="server"></asp:Label>
                                                            </td>
                                                            <td style="width: 60px;">
                                                                <%# Eval("InHandQty")%>
                                                            </td>
                                                            <td style="width: 60px;">
                                                                <%# Eval("RequestedQty")%>
                                                            </td>
                                                            <td style="width: 60px;">
                                                                <%# Eval("ApprovedQty")%>
                                                            </td>
                                                            <td style="width: 60px;">
                                                                <asp:Label ID="lbl" Visible="false" runat="server" Text='<%#Eval("ItemID")+"#"+ Eval("PurchaseRequisitionNo") %>'></asp:Label>
                                                               
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="8" style="padding-left: 20px">
                                                                <asp:Repeater ID="rptvender" runat="server" OnItemCommand="rpt_setvender" OnItemDataBound="rptvender_ItemDataBound">
                                                                    <HeaderTemplate>
                                                                        <table cellpadding="0">
                                                                            <tr style="text-align: center; color: #ee00ee; background-color: #f0fff0; width: 100%;">
                                                                                <th scope="col">S.No.
                                                                                </th>
                                                                                <th scope="col">Vendor
                                                                                </th>
                                                                                <th scope="col">Quot. No.
                                                                                </th>
                                                                                <th scope="col">Date
                                                                                </th>
                                                                                <th scope="col">Rate/Unit
                                                                                </th>
                                                                                <th scope="col">Disc.
                                                                                </th>
                                                                                <th scope="col">Tax
                                                                                </th>
                                                                                <th scope="col">Tax(%)
                                                                                </th>
                                                                                <th scope="col">Cost Price
                                                                                </th>
                                                                                <th scope="col">Total
                                                                                </th>
                                                                                <th scope="col">View</th>
                                                                                <th scope="col">Edit</th>
                                                                                <th scope="col">For Po
                                                                                </th>
                                                                                
                                                                            </tr>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <tr style="text-align: center; width: 100%;" id="Tr1" runat="server">
                                                                            <td style="width: 20px; text-align: left;">
                                                                                <%# Container.ItemIndex+1 %>
                                                                            </td>
                                                                            <td style="width: 240px; text-align:left">
                                                                                <%# Eval("Vendor")%>
                                                                            </td>
                                                                            <td style="width: 75px;text-align:left">
                                                                                <%# Eval("RefNo")%>
                                                                            </td>
                                                                            <td style="width: 100px;">
                                                                                <%# Eval("Date")%>
                                                                            </td>
                                                                            <td style="width: 50px;text-align:right">
                                                                                <%# Eval("Rate")%>
                                                                            </td>
                                                                            <td style="width: 50px;text-align:right">
                                                                                <%# Eval("Discount")%>
                                                                            </td>
                                                                            <td style="width: 75px;">
                                                                                <%# Eval("TaxName")%>
                                                                            </td>
                                                                            <td style="width: 50px;">
                                                                                <%# Eval("TaxPer")%>
                                                                            </td>
                                                                            <td style="width: 50px;text-align:right">
                                                                                <%# Eval("CostPrice")%>
                                                                            </td>
                                                                            <td style="width: 70px;text-align:right">
                                                                                <%# Eval("TotalCost")%>
                                                                            </td>
                                                                            <td style="width: 50px;">
                                                                                <a onclick="showtRecord('<%# Eval("ModelNumber")%>','<%# Eval("DeliveryTime")%>','<%# Eval("PaymentPattern")%>','<%# Eval("AMC")%>','<%#Eval("OperationalCost") %>','<%#Eval("SilentFeatures") %>','<%#Eval("AdditionalFeatures") %>','<%# Eval("ItemName")%>','<%# Eval("Vendor")%>','<%# Eval("RefNo")%>','<%# Eval("Date")%>','<%# Eval("Rate")%>','<%# Eval("Discount")%>','<%# Eval("TaxPer")%>','<%# Eval("CostPrice")%>','<%# Eval("TotalCost")%>','<%#Eval("Specification") %>','<%#Eval("UploadStatus") %>','<%#Eval("URL") %>');">
                                                                                    <img src="../../Images/view.GIF" alt="" />
                                                                                </a>
                                                                            </td>
                                                                            <td style="width: 50px;">
                                                                                <a class="fancybox" href="QuotationEdit.aspx?VendorID=<%# Eval("VendorID")%>&RefNo=<%# Eval("RefNo")%>&ItemID=<%#Eval("ItemId") %>">
                                                                                    <asp:ImageButton ID="Image1" ImageUrl="~/Images/edit.png" runat="server" /></a>
                                                                            </td>

                                                                            <td style="width: 80px;">
                                                                                <asp:Label ID="lblAppStatus" Visible="False" runat="server" Text='<%#Util.GetBoolean( Eval("AppStatus"))%>'></asp:Label>
                                                                                <asp:Button ID="btnset" runat="server" CausesValidation="false" Text="Set" CommandName="set"
                                                                                    CommandArgument='<%#Eval("VendorLedgerNo")+"#"+Eval("ItemID")+"#"+Eval("quotationID")+"#"+Eval("Rate")+"#"+Eval("qty")+"#"+Eval("PurchaseRequestNo")+"#"+Eval("StoreID")+"#"+Eval("VendorID")+"#"+Eval("Vendor") %>'
                                                                                    Visible='<%#Util.GetBoolean( Eval("AppStatus"))%>' CssClass="ItDoseButton" />
                                                                               
                                                                                <asp:Label ID="lblQuote_ID" runat="server" Visible="false" Text='<%# Eval("quotationID")%>' />
                                                                                <asp:Label ID="lblPRNo" runat="server" Visible="false" Text='<%# Eval("PurchaseRequestNo")%>' />
                                                                                <asp:Label ID="lblItemID" runat="server" Visible="false" Text='<%# Eval("ItemID")%>' />
                                                                                <asp:Label ID="lblSet" runat="server" Visible="false" Text='<%# Eval("IsSet")%>' />
                                                                                <asp:Label ID="lblStore" runat="server" Visible="false" Text='<%# Eval("StoreID")%>' />                                                                            
                                                                                <asp:Label ID="lblAutoPo" runat="server" Visible="false" Text='<%# Eval("AutoPo")%>' />
                                                                                <asp:Label ID="lblSetStatus" runat="server" Visible="false" Text='<%# Eval("SetStatus")%>' />
                                                                            </td>
                                                                           
                                                                            
                                                                        </tr>
                                                                    </ItemTemplate>

                                                                    <FooterTemplate>
                                                                        </table>
                                                                    </FooterTemplate>
                                                                </asp:Repeater>
                                                            </td>
                                                        </tr>
                                                    </ItemTemplate>
                                                    <FooterTemplate>
                                                        </table>
                                                    </FooterTemplate>
                                                </asp:Repeater>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        </table>
                                    </FooterTemplate>
                                </asp:Repeater>
                            </asp:Panel>

                        

                            

                        </div>
                      
                    </div>
                </div>
            </div>
        </div>
        <div id="dialog" style="background-color: aqua; display:none ">
            <table style="width:680px">
                <tr >
                    <td colspan="2" ><b>Item Name:</b> <span  id="ItemName"></span></td>
                </tr>
                <tr>
                    <td ><b>Quotation No.:</b> <span id="QuotationNo"></span></td>
                    <td ><b>Date:</b> <span  id="Date"></span></td>

                </tr>
                <tr>
                     <td ><b>Rate/Unit:</b> <span  id="RateUnit"></span></td>
                    <td ><b>Discount:</b> <span  id="Discount"></span></td>
                    
                </tr>
                <tr>
                   <td ><b>Tax(%):</b> <span id="TaxPer"></span></td>
                    <td ><b>Cost Price:</b> <span id="CostPrice"></span></td>
                </tr>
                <tr>
                    <td ><b>Modal Number:</b> <span id="ModalNumber"></span></td>
                    <td ><b>Delivery Time:</b> <span id="DeliveryTime"></span></td>
                </tr>
                <tr>
                    <td ><b>Operational Cost:</b> <span id="OperationalCost"></span></td>
                    <td ><b>AMC:</b> <span id="AMC"></span></td>
                </tr>
                <tr>
                    <td colspan="2" ><b>Payment Pattern:</b> <span id="PaymentPattern"></span></td>
                    
                </tr>
                <tr>
                    <td colspan="2" ><b>Silent Features:</b> <span id="SilentFeatures"></span></td>
                </tr>
                <tr>
                    <td colspan="2" ><b>Additional Features:</b> <span id="AdditionalFeatures"></span>
                    </td>
                </tr>
                
                 <tr>
                    <td colspan="2" ><b>Specification:</b> <span id="Specification"></span>
                    </td>
                </tr>
                <tr id="tdDoc">
                    <td colspan="2" ><b>Document:</b> 
                        <a id="Path" > <img id="imgUrlPath" src="../../Images/view.GIF" alt="" /> </a>
                                 <span id="UrlPath" style="display:none"></span>   
                          </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>
