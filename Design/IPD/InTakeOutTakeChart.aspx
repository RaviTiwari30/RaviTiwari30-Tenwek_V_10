<%@ Page Language="C#" AutoEventWireup="true" CodeFile="InTakeOutTakeChart.aspx.cs" Inherits="Design_IPD_InTakeOutTakeChart" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="../../Styles/jquery-ui.css" />

    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.js"></script>

    <script type="text/javascript" src="../../Scripts/jquery.extensions.js"></script>

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


    <style type="text/css">
        .auto-style1 {
            width: 175px;
        }

        .auto-style4 {
            width: 124px;
        }

        .auto-style5 {
            width: 127px;
        }
    </style>


</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <script type="text/javascript">
        function validate() {
            if (typeof (Page_Validators) == "undefined") return;
            var TimeON = document.getElementById("<%=maskTime.ClientID%>");

            var LblName = document.getElementById("<%=lblMsg.ClientID%>");
            if ($("#txtDate").val() == "") {
                $("#txtDate").focus();

                $("#<%=lblMsg.ClientID%>").text('Please Select Date');
                return false;
            }
            ValidatorValidate(TimeON);
            if (!TimeON.isvalid) {
                LblName.innerText = TimeON.errormessage;
                $("#txtTime").focus();
                return false;
            }

        }
    </script>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>InTake OutPut Chart </b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

                <asp:Label ID="lblPatientId" runat="server" ClientIDMode="Static" Style="display: none"></asp:Label>
                <asp:Label ID="lblTransactionId" runat="server" ClientIDMode="Static" Style="display: none"></asp:Label>
            </div>

            <div class="POuter_Box_Inventory" style="text-align: center;">

                <table style="width: 100%; border: solid thin">

                    <tr>
                        <td style="width: 20%; border: solid thin; border-spacing: 0;">
                            <table style="width: 100%;">
                                <thead>
                                    <tr>
                                        <th style="width: 50%; border: 1px solid medium">Date</th>
                                        <th style="width: 50%;">Time</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr style="height: 18px">
                                        <td style=""></td>
                                    </tr>
                                    <tr style="height: 58px">
                                        <td style="border: 1px; border-top: solid; border-bottom: solid" colspan="2"><em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em></td>
                                    </tr>
                                    <tr>
                                        <td style="border: 1px; border-right: solid black" class="auto-style4">
                                            <asp:TextBox ID="txtDate" ClientIDMode="Static" runat="server" Width="80px"></asp:TextBox>
                                            <asp:Label ID="lblV" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                                            <cc1:CalendarExtender ID="calDate" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                                        </td>
                                        <td style="border: 1px; border-right: solid black" class="auto-style4">
                                            <asp:TextBox ID="txtTime" runat="server" Width="80px" ClientIDMode="Static" CssClass="ItDoseTextinputText"></asp:TextBox>
                                            <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label></td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                        <td style="width: 80%; border: solid thin">
                            <table style="width: 100%;">
                                <thead>
                                    <tr>
                                        <th style="width: 50%; border-bottom: solid" colspan="7">INTAKE(in ml) </th>
                                        <th style="width: 50%; border-bottom: solid" colspan="7">OUTPUT(in ml)  </th>
                                    </tr>
                                    <tr>
                                        <th style="border: 1px; border-bottom: solid black" class="auto-style4" colspan="3">Intravenous</th>
                                        <th style="border: 1px; border-bottom: solid black; border-right: solid black;" class="auto-style4" colspan="4">Feeds</th>
                                        <th style="border: 1px; border-bottom: solid black" class="auto-style4" colspan="7"></th>
                                    </tr>

                                    <tr>

                                        <th style="width: 15%; border: 1px; border-right: solid black; border-bottom: solid black" class="auto-style4">Fluid No</th>
                                        <th style="width: 15%; border: 1px; border-right: solid black; border-bottom: solid black" class="auto-style4">Type</th>
                                        <th style="width: 15%; border: 1px; border-right: solid black; border-bottom: solid black" class="auto-style4">Infused</th>
                                        <th style="width: 15%; border: 1px; border-right: solid black; border-bottom: solid black" class="auto-style4">PO Type</th>
                                        <th style="width: 20%; border: 1px; border-right: solid black; border-bottom: solid black" class="auto-style4">Amount</th>
                                        <th style="width: 10%; border: 1px; border-right: solid black; border-bottom: solid black" class="auto-style4">Tube Type</th>
                                        <th style="width: 10%; border: 1px; border-right: solid black; border-bottom: solid black" class="auto-style4">Amount</th>
                                        <th style="width: 15%; border: 1px; border-right: solid black; border-bottom: solid black" class="auto-style4">Vomit</th>
                                        <th style="width: 15%; border: 1px; border-right: solid black; border-bottom: solid black" class="auto-style4">Stool</th>
                                        <th style="width: 15%; border: 1px; border-right: solid black; border-bottom: solid black" class="auto-style4">N.G</th>
                                        <th style="width: 15%; border: 1px; border-right: solid black; border-bottom: solid black" class="auto-style4">Urine</th>
                                        <th style="width: 20%; border: 1px; border-right: solid black; border-bottom: solid black" class="auto-style4">Drain 1/Chest Tube 1</th>
                                        <th style="width: 10%; border: 1px; border-right: solid black; border-bottom: solid black" class="auto-style4">Drain 2/Chest Tube 2</th>
                                        <th style="width: 10%; border: 1px; border-right: solid black; border-bottom: solid black" class="auto-style4">Drain 3/Chest Tube 3</th>

                                    </tr>

                                </thead>
                                <tbody>
                                    <tr>
                                        <td style="border: 1px; border-right: solid black" class="auto-style4">
                                            <asp:TextBox Style="width: 60px;" runat="server" TextMode="Number" ID="txtFluidNo"></asp:TextBox></td>
                                        <td style="border: 1px; border-right: solid black" class="auto-style4">
                                            <asp:TextBox Style="width: 60px;" runat="server" ID="txtType" ClientIDMode="Static"></asp:TextBox></td>
                                        <td style="border: 1px; border-right: solid black" class="auto-style4">
                                            <asp:TextBox Style="width: 60px;" runat="server" ID="txtInfused" ClientIDMode="Static" TextMode="Number"></asp:TextBox></td>
                                        <td style="border: 1px; border-right: solid black" class="auto-style4">
                                            <asp:TextBox Style="width: 60px;" runat="server" ID="txtPOType" ClientIDMode="Static"></asp:TextBox></td>
                                        <td style="border: 1px; border-right: solid black" class="auto-style4">
                                            <asp:TextBox Style="width: 60px;" runat="server" ID="txtPoAmount" ClientIDMode="Static" TextMode="Number"></asp:TextBox></td>
                                        <td style="border: 1px; border-right: solid black" class="auto-style4">
                                            <asp:TextBox Style="width: 60px;" runat="server" ID="txtTubeType" ClientIDMode="Static"></asp:TextBox></td>
                                        <td style="border: 1px; border-right: solid black" class="auto-style4">
                                            <asp:TextBox Style="width: 60px;" runat="server" ID="txtTubeAmount" ClientIDMode="Static" TextMode="Number"></asp:TextBox></td>

                                        <td style="border: 1px; border-right: solid black" class="auto-style4">
                                            <asp:TextBox Style="width: 60px;" runat="server" ID="txtVomit" ClientIDMode="Static" TextMode="Number"></asp:TextBox></td>
                                        <td style="border: 1px; border-right: solid black" class="auto-style4">
                                            <asp:TextBox Style="width: 60px;" runat="server" ID="txtStool" ClientIDMode="Static" TextMode="Number"></asp:TextBox></td>
                                        <td style="border: 1px; border-right: solid black" class="auto-style4">
                                            <asp:TextBox Style="width: 60px;" runat="server" ID="txtNG" ClientIDMode="Static" TextMode="Number"></asp:TextBox></td>
                                        <td style="border: 1px; border-right: solid black" class="auto-style4">
                                            <asp:TextBox Style="width: 60px;" runat="server" ID="txtUrine" ClientIDMode="Static" TextMode="Number"></asp:TextBox></td>
                                        <td style="border: 1px; border-right: solid black" class="auto-style4">
                                            <asp:TextBox Style="width: 60px;" runat="server" ID="txtDrain1" ClientIDMode="Static" TextMode="Number"></asp:TextBox></td>
                                        <td style="border: 1px; border-right: solid black" class="auto-style4">
                                            <asp:TextBox Style="width: 60px;" runat="server" ID="txtDrain2" ClientIDMode="Static" TextMode="Number"></asp:TextBox></td>
                                        <td style="border: 1px; border-right: solid black" class="auto-style4">
                                            <asp:TextBox Style="width: 60px;" runat="server" ID="txtDrain3" ClientIDMode="Static" TextMode="Number"></asp:TextBox></td>

                                    </tr>
                                </tbody>
                            </table>


                        </td>

                    </tr>

                </table>

                <div class="row">
                    <div class="col-md-3">
                        Comments :
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtRemark" runat="server" ClientIDMode="Static" TextMode="MultiLine" Style="width: 800px">

                        </asp:TextBox>
                    </div>
                </div>

                <asp:Label ID="lblFillTime" runat="server" Style="display: none" Text="0"></asp:Label>
                <asp:Label ID="lblID" runat="server" Visible="false"></asp:Label>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <input id="btnSave" type="button" value="Save" onclick="SaveData()" />
                <asp:Button ID="btnPrint" runat="server" Text="Print" OnClick="btnPrint_Click" CssClass="ItDoseButton" />
            </div>




            <div class="POuter_Box_Inventory" style="text-align: center; background-color: #f1c90d">
                <b>Current Date 6 AM To Till time </b>
            </div>
            <div class="col-md-24" id="bindTodayAfter6AM">

                <table style="width: 100%;" id="tblBindTodayAfter6datapart">
                    <thead>
                        <tr>
                          <th class="GridViewHeaderStyle" rowspan="2" valign="top">Date</th>
                            <th class="GridViewHeaderStyle" rowspan="2" valign="top">Time</th>
                            <th class="GridViewHeaderStyle" colspan="7">INTAKE(in ml) </th>
                            <th class="GridViewHeaderStyle" colspan="10">OUTPUT(in ml)  </th>
                        </tr>
                        <tr>
                            <th class="GridViewHeaderStyle" colspan="2"></th>
                            <th class="GridViewHeaderStyle" colspan="3">Intravenous</th>
                            <th class="GridViewHeaderStyle" colspan="4">Feeds</th>
                            <th class="GridViewHeaderStyle" colspan="10"></th>
                        </tr>

                        <tr>
                            <th class="GridViewHeaderStyle" colspan="2"></th>
                            <th class="GridViewHeaderStyle">Fluid No</th>
                            <th class="GridViewHeaderStyle">Type</th>
                            <th class="GridViewHeaderStyle">Infused</th>
                            <th class="GridViewHeaderStyle">PO Type</th>
                            <th class="GridViewHeaderStyle">Amount</th>
                            <th class="GridViewHeaderStyle">Tube Type</th>
                            <th class="GridViewHeaderStyle">Amount</th>
                            <th class="GridViewHeaderStyle">Vomit</th>
                            <th class="GridViewHeaderStyle">Stool</th>
                            <th class="GridViewHeaderStyle">N.G</th>
                            <th class="GridViewHeaderStyle">Urine</th>
                            <th class="GridViewHeaderStyle">Drain 1/Chest Tube 1</th>
                            <th class="GridViewHeaderStyle">Drain 2/Chest Tube 2</th>
                            <th class="GridViewHeaderStyle">Drain 3/Chest Tube 3</th>
                            <th class="GridViewHeaderStyle">Remark</th>
                            <th class="GridViewHeaderStyle">Sign</th>
                            <th class="GridViewHeaderStyle">Action</th>

                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>



            </div>
            <div class="POuter_Box_Inventory" style="text-align: center; font-weight: bolder; background-color: pink">
                Previous Date 6 AM to Current Date 6 AM
            </div>


            <div class="col-md-24" id="bindYesterdayAfter6AM">


                <table style="width: 100%;" id="tblYesterdayAfter6data">
                    <thead>
                        <tr>
                          <th class="GridViewHeaderStyle" rowspan="2" valign="top">Date</th>
                            <th class="GridViewHeaderStyle" rowspan="2" valign="top">Time</th>
                            <th class="GridViewHeaderStyle" colspan="7">INTAKE(in ml) </th>
                            <th class="GridViewHeaderStyle" colspan="10">OUTPUT(in ml)  </th>
                        </tr>
                        <tr>
                            <th class="GridViewHeaderStyle" colspan="2"></th>
                            <th class="GridViewHeaderStyle" colspan="3">Intravenous</th>
                            <th class="GridViewHeaderStyle" colspan="4">Feeds</th>
                            <th class="GridViewHeaderStyle" colspan="10"></th>
                        </tr>

                        <tr>
                            <th class="GridViewHeaderStyle" colspan="2"></th>
                            <th class="GridViewHeaderStyle">Fluid No</th>
                            <th class="GridViewHeaderStyle">Type</th>
                            <th class="GridViewHeaderStyle">Infused</th>
                            <th class="GridViewHeaderStyle">PO Type</th>
                            <th class="GridViewHeaderStyle">Amount</th>
                            <th class="GridViewHeaderStyle">Tube Type</th>
                            <th class="GridViewHeaderStyle">Amount</th>
                            <th class="GridViewHeaderStyle">Vomit</th>
                            <th class="GridViewHeaderStyle">Stool</th>
                            <th class="GridViewHeaderStyle">N.G</th>
                            <th class="GridViewHeaderStyle">Urine</th>
                            <th class="GridViewHeaderStyle">Drain 1/Chest Tube 1</th>
                            <th class="GridViewHeaderStyle">Drain 2/Chest Tube 2</th>
                            <th class="GridViewHeaderStyle">Drain 3/Chest Tube 3</th>
                            <th class="GridViewHeaderStyle">Remark</th>
                            <th class="GridViewHeaderStyle">Sign</th>
                            <th class="GridViewHeaderStyle">Action</th>

                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>




            </div>

            <div class="POuter_Box_Inventory" style="text-align: center; background-color: greenyellow">
                All Date  Data
            </div>


            <div class="col-md-24" id="BindPreviousdata">

                <table style="width: 100%;" id="tblBindPreviousdata">
                    <thead>
                        <tr>
                           <th class="GridViewHeaderStyle" rowspan="2" valign="top">Date</th>
                            <th class="GridViewHeaderStyle" rowspan="2" valign="top">Time</th>
                            <th class="GridViewHeaderStyle" colspan="7">INTAKE(in ml) </th>
                            <th class="GridViewHeaderStyle" colspan="10">OUTPUT(in ml)  </th>
                        </tr>
                        <tr>
                            <th class="GridViewHeaderStyle" colspan="2"></th>
                            <th class="GridViewHeaderStyle" colspan="3">Intravenous</th>
                            <th class="GridViewHeaderStyle" colspan="4">Feeds</th>
                            <th class="GridViewHeaderStyle" colspan="10"></th>
                        </tr>

                        <tr>
                            <th class="GridViewHeaderStyle" colspan="2"></th>
                            <th class="GridViewHeaderStyle">Fluid No</th>
                            <th class="GridViewHeaderStyle">Type</th>
                            <th class="GridViewHeaderStyle">Infused</th>
                            <th class="GridViewHeaderStyle">PO Type</th>
                            <th class="GridViewHeaderStyle">Amount</th>
                            <th class="GridViewHeaderStyle">Tube Type</th>
                            <th class="GridViewHeaderStyle">Amount</th>
                            <th class="GridViewHeaderStyle">Vomit</th>
                            <th class="GridViewHeaderStyle">Stool</th>
                            <th class="GridViewHeaderStyle">N.G</th>
                            <th class="GridViewHeaderStyle">Urine</th>
                            <th class="GridViewHeaderStyle">Drain 1/Chest Tube 1</th>
                            <th class="GridViewHeaderStyle">Drain 2/Chest Tube 2</th>
                            <th class="GridViewHeaderStyle">Drain 3/Chest Tube 3</th>
                            <th class="GridViewHeaderStyle">Remark</th>
                            <th class="GridViewHeaderStyle">Sign</th>
                            <th class="GridViewHeaderStyle">Action</th>

                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                    <tfoot>
                        <tr>                            
                            <th class="GridViewHeaderStyle" colspan="4">TOTAL INTAKE</th>
                            <th class="GridViewHeaderStyle"><span id="spanTotalIntake"></span></th>
                            <th class="GridViewHeaderStyle"></th>
                            <th class="GridViewHeaderStyle"></th>
                            <th class="GridViewHeaderStyle"></th>
                            <th class="GridViewHeaderStyle" colspan="4">TOTAL OUTTAKE</th>
                            <th class="GridViewHeaderStyle"><span id="spanTotalOuttake"></span></th>
                            <th class="GridViewHeaderStyle">BALANCE</th>
                            <th class="GridViewHeaderStyle"><span id="spanBal"></span></th>
                            <th class="GridViewHeaderStyle"></th>
                            <th class="GridViewHeaderStyle"><span id="spanRemarkDiff"></span></th>
                            <th class="GridViewHeaderStyle"></th>
                            <th class="GridViewHeaderStyle"></th>
                        </tr>

                    </tfoot>
                </table>


                <div class="POuter_Box_Inventory" style="background-color: #dbded6; padding-bottom: 31px;">

                    <div class="row">

                        <div class="col-md-4" style="text-align: right; font-weight: bolder; font-size: 12px">
                            INTRAVENOUS :
                        </div>
                        <div class="col-md-4">
                            <label id="lblIntravenous" style="text-align: left; font-weight: bolder; font-size: 12px"></label>
                        </div>
                        <div class="col-md-4" style="text-align: right; font-weight: bolder; font-size: 12px">
                            TOTAL INTAKE:
                        </div>
                        <div class="col-md-4">
                            <label id="lblTotalIntake" style="text-align: left; font-weight: bolder; font-size: 12px"></label>
                        </div>
                        <div class="col-md-4" style="text-align: right; font-weight: bolder; font-size: 12px">
                            VOMIT :
                        </div>
                        <div class="col-md-4">
                            <label id="lblVomit" style="text-align: left; font-weight: bolder; font-size: 12px"></label>
                        </div>


                    </div>

                    <div class="row">

                        <div class="col-md-4" style="text-align: right; font-weight: bolder; font-size: 12px">
                            Feeds :
                        </div>
                        <div class="col-md-4">
                            <label id="lblFeeds" style="text-align: left; font-weight: bolder; font-size: 12px"></label>
                        </div>
                        <div class="col-md-4" style="text-align: right; font-weight: bolder; font-size: 12px">
                            TOTAL OUTPUT :
                        </div>
                        <div class="col-md-4">
                            <label id="lblTotalOutput" style="text-align: left; font-weight: bolder; font-size: 12px"></label>
                        </div>
                        <div class="col-md-4" style="text-align: right; font-weight: bolder; font-size: 12px">
                            STOOL :
                        </div>
                        <div class="col-md-4">
                            <label id="lblStool" style="text-align: left; font-weight: bolder; font-size: 12px"></label>
                        </div>


                    </div>


                    <div class="row">

                        <div class="col-md-4" style="text-align: right; font-weight: bolder; font-size: 12px">
                        </div>
                        <div class="col-md-4">
                        </div>
                        <div class="col-md-4" style="text-align: right; font-weight: bolder; font-size: 12px">
                        </div>
                        <div class="col-md-4">
                        </div>
                        <div class="col-md-4" style="text-align: right; font-weight: bolder; font-size: 12px">
                            NASO GAST :
                        </div>
                        <div class="col-md-4">
                            <label id="lblNG" style="text-align: left; font-weight: bolder; font-size: 12px"></label>
                        </div>


                    </div>



                    <div class="row">

                        <div class="col-md-4" style="text-align: right; font-weight: bolder; font-size: 12px">
                        </div>
                        <div class="col-md-4">
                        </div>
                        <div class="col-md-4" style="text-align: right; font-weight: bolder; font-size: 12px">
                        </div>
                        <div class="col-md-4">
                        </div>
                        <div class="col-md-4" style="text-align: right; font-weight: bolder; font-size: 12px">
                            URINE :
                        </div>
                        <div class="col-md-4">
                            <label id="lblUrine" style="text-align: left; font-weight: bolder; font-size: 12px"></label>
                        </div>


                    </div>

                    <div class="row">

                        <div class="col-md-4" style="text-align: right; font-weight: bolder; font-size: 12px">
                            TOTAL INTAKE (A) :
                        </div>
                        <div class="col-md-4">
                            <label id="lblTotalA" style="text-align: left; font-weight: bolder; font-size: 12px"></label>
                        </div>
                        <div class="col-md-4" style="text-align: right; font-weight: bolder; font-size: 12px">
                        </div>
                        <div class="col-md-4">
                        </div>
                        <div class="col-md-4" style="text-align: right; font-weight: bolder; font-size: 12px">
                            TOTAL OUTPUT(B) :
                        </div>
                        <div class="col-md-4">
                            <label id="lblTotalB" style="text-align: left; font-weight: bolder; font-size: 12px"></label>
                        </div>


                    </div>

                    <div class="row">

                        <div class="col-md-4" style="text-align: right; font-weight: bolder; font-size: 12px">
                            Difference(A-B) =
                        </div>
                        <div class="col-md-4">
                            <label id="lblDiff" style="text-align: left; font-weight: bolder; font-size: 12px"></label>
                        </div>
                        <div class="col-md-4" style="text-align: right; font-weight: bolder; font-size: 12px">
                        </div>
                        <div class="col-md-4">
                        </div>
                        <div class="col-md-4" style="text-align: right; font-weight: bolder; font-size: 12px">
                        </div>
                        <div class="col-md-4">
                        </div>


                    </div>


                </div>
            </div>
        </div>

        <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time"
            TargetControlID="txtTime" AcceptAMPM="True">
        </cc1:MaskedEditExtender>
        <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtTime"
            ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Please Enter Time"
            InvalidValueMessage="Invalid Time ON" Display="None"></cc1:MaskedEditValidator>
        <script type="text/javascript">
            function checkForSecond(sender, e) {
                formatBox = document.getElementById(sender.id);
                strLen = sender.value.length;
                strVal = sender.value;
                hasDec = false;
                e = (e) ? e : (window.event) ? event : null;


                if (e) {
                    var charCode = (e.charCode) ? e.charCode :
                                ((e.keyCode) ? e.keyCode :
                                ((e.which) ? e.which : 0));


                    if ((charCode == 47)) {
                        for (var i = 0; i < strLen; i++) {
                            hasDec = (strVal.charAt(i) == '/');
                            if (hasDec)
                                return false;
                        }
                    }
                }
                return true;
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
            function checkForPulse(sender, e) {
                formatBox = document.getElementById(sender.id);
                strLen = sender.value.length;
                strVal = sender.value;
                hasDec = false;
                e = (e) ? e : (window.event) ? event : null;


                if (e) {
                    var charCode = (e.charCode) ? e.charCode :
                                ((e.keyCode) ? e.keyCode :
                                ((e.which) ? e.which : 0));


                    if ((charCode == 46) || (charCode == 110) || (charCode == 190) || (charCode == 45)) {
                        for (var i = 0; i < strLen; i++) {
                            hasDec = (strVal.charAt(i) == '-');
                            if (hasDec)
                                return false;
                        }
                    }
                }
                return true;
            }

        </script>

        <script type="text/javascript">

            $(document).ready(function () {

                Search(0);
                Search(1);
                Search(2);

            });
            function GetDetails() {


                var obj = new Object();
                obj.DATE = $("#txtDate").val();
                obj.TIME = $("#txtTime").val();
                obj.PatientID = $("#lblPatientId").text();
                obj.TransactionID = $("#lblTransactionId").text();
                obj.FluidNo = $("#txtFluidNo").val();
                obj.Type = $("#txtType").val();
                obj.Infused = $("#txtInfused").val();
                obj.POType = $("#txtPOType").val();
                obj.POAmount = $("#txtPoAmount").val();
                obj.TubeType = $("#txtTubeType").val();
                obj.TubeAmount = $("#txtTubeAmount").val();
                obj.Vomit = $("#txtVomit").val();
                obj.Stool = $("#txtStool").val();

                obj.NG = $("#txtNG").val();
                obj.Urine = $("#txtUrine").val();
                obj.Drain1 = $("#txtDrain1").val();
                obj.Drain2 = $("#txtDrain2").val();
                obj.Drain3 = $("#txtDrain3").val();
                obj.Remark = $("#txtRemark").val();

                return obj;
            }



            var SaveData = function () {
                var res = GetDetails();

                $('#btnSave').attr('disabled', true).val("Submitting...");

                $.ajax({
                    url: "InTakeOutTakeChart.aspx/SaveIntakeOutTake",
                    data: JSON.stringify({ item: res }),
                    type: "Post",
                    contentType: "application/json; charset=utf-8",
                    timeout: "120000",
                    async: false,
                    dataType: "json",
                    success: function (result) {

                        var responseData = JSON.parse(result.d);
                        var btnSave = $('#btnSave');

                        modelAlert(responseData.Msg, function () {

                            if (responseData.status) {
                                window.location.reload();
                            }
                            else
                                $(btnSave).removeAttr('disabled').val('Save');

                        });



                    }
                });

            }




            function Search(Typ) {

                serverCall('InTakeOutTakeChart.aspx/GetDataDetails', { Typ: Typ, Pid: $("#lblPatientId").text(), Tid: $("#lblTransactionId").text() }, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.status) {
                        bindData(responseData.data, Typ);
                    } else {
                        if (Typ == 0) {

                        } else if (Typ == 1) {

                        } else {

                        }
                    }

                });
            }

            function bindData(data, Typ) {

                if (Typ == 0) {
                    $("#tblBindTodayAfter6DateTime tbody").empty();
                    $("#tblBindTodayAfter6datapart tbody").empty();


                } else if (Typ == 1) {

                    $("#tblYesterdayAfter6DateTime tbody").empty();
                    $("#tblYesterdayAfter6data tbody").empty();

                } else {
                    $("#tblBindPreviousdataDateTime tbody").empty();
                    $("#tblBindPreviousdata tbody").empty();

                }

                var Height = "25px";
                if (Typ == 2) {
                    Height = "32px"
                }
                var count = 0;
                $.each(data, function (i, item) {

                    var datarow = "";


                    if (Typ == 2) {

                        if ((i + 1) == data.length) {


                            $("#lblIntravenous").text(item.Infused)
                            $("#lblTotalIntake").text((item.Infused) + (item.POAmount) + (item.TubeAmount))
                            $("#spanTotalIntake").text((item.Infused) + (item.POAmount) + (item.TubeAmount));
                            $("#lblTotalA").text((item.Infused) + (item.POAmount) + (item.TubeAmount))

                            $("#lblVomit").text(item.Vomit)

                            $("#lblFeeds").text(item.POAmount)
                            $("#lblTotalOutput").text((item.Vomit) + (item.Stool) + (item.NG) + (item.Urine) + (item.Drain1) + (item.Drain2) + (item.Drain3))
                            $("#spanTotalOuttake").text((item.Vomit) + (item.Stool) + (item.NG) + (item.Urine) + (item.Drain1) + (item.Drain2) + (item.Drain3))
                            $("#lblTotalB").text((item.Vomit) + (item.Stool) + (item.NG) + (item.Urine) + (item.Drain1) + (item.Drain2) + (item.Drain3))
                            $("#spanBal").text(((item.Infused) + (item.POAmount) + (item.TubeAmount)) - ((item.Vomit) + (item.Stool) + (item.NG) + (item.Urine) + (item.Drain1) + (item.Drain2) + (item.Drain3)));
                            $("#spanRemarkDiff").text(((item.Infused) + (item.POAmount) + (item.TubeAmount)) - ((item.Vomit) + (item.Stool) + (item.NG) + (item.Urine) + (item.Drain1) + (item.Drain2) + (item.Drain3)));

                            $("#lblDiff").text(((item.Infused) + (item.POAmount) + (item.TubeAmount)) - ((item.Vomit) + (item.Stool) + (item.NG) + (item.Urine) + (item.Drain1) + (item.Drain2) + (item.Drain3)))


                            $("#lblStool").text(item.Stool)

                            $("#lblUrine").text(item.Urine)
                            $("#lblNG").text(item.NG)
                            $("#lblIntravenous").text(item.Infused)



                            datarow += '<tr style="height: ' + Height + '">';
                              
                            datarow += '<td class="GridViewItemStyle" colspan="4" style="text-align: right;font-weight:bolder;font-size: 15px;">' + item.Type + '</td>';
                            datarow += '<td class="GridViewItemStyle" style="text-align: center;font-weight:bolder;"><label>' + item.Infused + '</label></td>';
                            datarow += '<td class="GridViewItemStyle"  >' + item.POType + '</td>';
                            datarow += '<td class="GridViewItemStyle" style="text-align: center;font-weight:bolder;">' + item.POAmount + '</td>';
                            datarow += '<td class="GridViewItemStyle" >' + item.TubeType + '</td>';
                            datarow += '<td class="GridViewItemStyle" style="text-align: center;font-weight:bolder;">' + item.TubeAmount + '</td>';

                            datarow += '<td class="GridViewItemStyle" style="text-align: center;font-weight:bolder;">' + item.Vomit + '</td>';
                            datarow += '<td class="GridViewItemStyle" style="text-align: center;font-weight:bolder;">' + item.Stool + '</td>';
                            datarow += '<td class="GridViewItemStyle" style="text-align: center;font-weight:bolder;">' + item.NG + '</td>';
                            datarow += '<td class="GridViewItemStyle" style="text-align: center;font-weight:bolder;">' + item.Urine + '</td>';
                            datarow += '<td class="GridViewItemStyle" style="text-align: center;font-weight:bolder;">' + item.Drain1 + '</td>';
                            datarow += '<td class="GridViewItemStyle" style="text-align: center;font-weight:bolder;">' + item.Drain2 + '</td>';
                            datarow += '<td class="GridViewItemStyle" style="text-align: center;font-weight:bolder;">' + item.Drain3 + '</td>';
                            datarow += '<td class="GridViewItemStyle" colspan="3">' + $("#spanRemarkDiff").text() + '</td>';



                            datarow += "</tr>";


                        } else {

                            datarow += '<tr style="height:' + Height + '">';
                            datarow += '<td class="GridViewItemStyle">' + item.DATE + '</td>';
                            datarow += '<td class="GridViewItemStyle">' + item.TIME + '</td>';

                            datarow += '<td class="GridViewItemStyle"  >' + item.FluidNo + '</td>';
                            datarow += '<td class="GridViewItemStyle" >' + item.Type + '</td>';
                            datarow += '<td class="GridViewItemStyle"  >' + item.Infused + '</td>';
                            datarow += '<td class="GridViewItemStyle"  >' + item.POType + '</td>';
                            datarow += '<td class="GridViewItemStyle"  >' + item.POAmount + '</td>';
                            datarow += '<td class="GridViewItemStyle" >' + item.TubeType + '</td>';
                            datarow += '<td class="GridViewItemStyle"  >' + item.TubeAmount + '</td>';

                            datarow += '<td class="GridViewItemStyle"  >' + item.Vomit + '</td>';
                            datarow += '<td class="GridViewItemStyle"  >' + item.Stool + '</td>';
                            datarow += '<td class="GridViewItemStyle"  >' + item.NG + '</td>';
                            datarow += '<td class="GridViewItemStyle"  >' + item.Urine + '</td>';
                            datarow += '<td class="GridViewItemStyle" >' + item.Drain1 + '</td>';
                            datarow += '<td class="GridViewItemStyle"  >' + item.Drain2 + '</td>';
                            datarow += '<td class="GridViewItemStyle"  >' + item.Drain3 + '</td>';
                            datarow += '<td class="GridViewItemStyle"  >' + item.Remark + '</td>';
                            datarow += '<td class="GridViewItemStyle"  >' + item.EntryByName + '</td>';
                            if (item.CanDelete == 1) {
                                datarow += '<td class="GridViewItemStyle" style="width: 50px;"><input style="float:right" type="button" value="Delete" data-title="Click to Delete" onclick="Delete(' + item.ID + ')"/></td>';


                            }
                            else {
                                datarow += '<td class="GridViewItemStyle"  > </td>';


                            }

                            datarow += "</tr>";

                        }



                    }
                    else {



                        datarow += '<tr style="height:' + Height + '">';
                        datarow += '<td class="GridViewItemStyle">' + item.DATE + '</td>';
                        datarow += '<td class="GridViewItemStyle">' + item.TIME + '</td>';

                        datarow += '<td class="GridViewItemStyle" style="width: 50px;">' + item.FluidNo + '</td>';
                        datarow += '<td class="GridViewItemStyle" style="width: 50px;">' + item.Type + '</td>';
                        datarow += '<td class="GridViewItemStyle" style="width: 50px;">' + item.Infused + '</td>';
                        datarow += '<td class="GridViewItemStyle" style="width: 50px;">' + item.POType + '</td>';
                        datarow += '<td class="GridViewItemStyle" style="width: 50px;">' + item.POAmount + '</td>';
                        datarow += '<td class="GridViewItemStyle" style="width: 50px;">' + item.TubeType + '</td>';
                        datarow += '<td class="GridViewItemStyle" style="width: 50px;">' + item.TubeAmount + '</td>';

                        datarow += '<td class="GridViewItemStyle" style="width: 50px;">' + item.Vomit + '</td>';
                        datarow += '<td class="GridViewItemStyle" style="width: 50px;">' + item.Stool + '</td>';
                        datarow += '<td class="GridViewItemStyle" style="width: 50px;">' + item.NG + '</td>';
                        datarow += '<td class="GridViewItemStyle" style="width: 50px;">' + item.Urine + '</td>';
                        datarow += '<td class="GridViewItemStyle" style="width: 50px;">' + item.Drain1 + '</td>';
                        datarow += '<td class="GridViewItemStyle" style="width: 50px;">' + item.Drain2 + '</td>';
                        datarow += '<td class="GridViewItemStyle" style="width: 50px;">' + item.Drain3 + '</td>';
                        datarow += '<td class="GridViewItemStyle" style="width: 50px;">' + item.Remark + '</td>';
                        datarow += '<td class="GridViewItemStyle" style="width: 50px;">' + item.EntryByName + '</td>';
                        if (item.CanDelete == 1) {
                            datarow += '<td class="GridViewItemStyle" style="width: 50px;"><input style="float:right" type="button" value="Delete" data-title="Click to Delete" onclick="Delete(' + item.ID + ')"/></td>';


                        }
                        else {
                            datarow += '<td class="GridViewItemStyle" style="width: 50px;"> </td>';


                        }

                        datarow += "</tr>";



                    }



                    if (Typ == 0) {


                        $("#tblBindTodayAfter6datapart tbody").append(datarow);

                    } else if (Typ == 1) {

                        $("#tblYesterdayAfter6data tbody").append(datarow);
                    } else {

                        $("#tblBindPreviousdata tbody").append(datarow);
                    }

                });



            }


            function Delete(Id) {
                modelConfirmation('Are You Sure ?', 'To Delete the Selected', 'Yes', 'No', function (res) {
                    if (res) {

                        serverCall('InTakeOutTakeChart.aspx/Delete', { Id: Id }, function (response) {
                            var responseData = JSON.parse(response);
                            if (responseData.status) {
                                Search(0);
                                Search(1);
                                Search(2);
                                modelAlert(responseData.Msg);
                            } else {
                                modelAlert(responseData.Msg);
                            }

                        });


                    }
                });
            }

        </script>


    </form>

</body>
</html>
