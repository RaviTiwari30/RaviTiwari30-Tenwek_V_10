<%@ Page Language="C#" AutoEventWireup="true" CodeFile="InfusionMedicationRecord.aspx.cs" Inherits="Design_CPOE_InfusionMedicationRecord" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <%--<link rel="stylesheet" href="../../Styles/PurchaseStyle.css" type="text/css" />--%>
     <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script language="javascript" src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script type="text/javascript"> 

    </script>
    <style type="text/css">
        .auto-style1 {
            color: #CC3300;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Infusion Medication Administration Record</b><br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
            <div class="POuter_Box_Inventory">
                <table width="100%">
                    <tr>
                         <td style="text-align:left;width:20px; display:none;">
                             <asp:DropDownList ID="ddldrugType" runat="server" Width="120px" AutoPostBack="true" OnSelectedIndexChanged="ddldrugType_SelectedIndexChanged"> 
                                 <asp:ListItem Value="LSHHI5">Medicines</asp:ListItem>
                                 <asp:ListItem Value="LSHHI38">Medical Consumables</asp:ListItem>
                             </asp:DropDownList>
                         </td>
                        <td style="text-align: center; background-color:lightgreen;"><strong>Today Medicine</strong></td>
                        <td></td>
                        <td style="text-align: center; background-color: white;"><strong>Running</strong></td>
                        <td></td>
                        <td style="text-align: center; background-color: lightblue;"><strong>Not Issued</strong></td>
                        <td></td>
                        <td style="text-align: center; background-color: yellow;"><strong>Completed</strong></td>
                        <td></td>
                        <td style="text-align: center; background-color: red;"><strong>Stopped</strong></td>
                    </tr>
                    <tr style="display:none">
                        <td colspan="7" style="text-align: left"><span class="auto-style1"><strong>Note:</strong></span> <strong>
                            <br class="auto-style1" />
                            <span class="auto-style1">1.</span></strong><span class="auto-style1"> In case of Completed, Either the Duration is finished OR the Remaining Qty. is 0)</span><br class="auto-style1" />
                            <span class="auto-style1"><strong>2.&nbsp; </strong>If medicine Name is brown color and large means it is a outside medicine.</span></td>
                    </tr>
                    <tr>
                        <td colspan="10">
                            <asp:Panel runat="server" ID="pnlMedicine" Width="100%">
                                <asp:Repeater ID="rptMedicine" runat="server" OnItemCommand="rptMedicine_ItemCommand" OnItemDataBound="rptMedicine_ItemDataBound">
                                    <HeaderTemplate>
                                        <table class="GridViewStyle" cellspacing="0" style="border-collapse: collapse;">
                                            <tr style="text-align: center; background-color: #afeeee;">
                                                <th class="GridViewHeaderStyle" scope="col">&nbsp;
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col">S.No.
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col">Medicine Name
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col">Entry Date Time
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col" style="display:none">Order Qty.
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col" style="display:none">Issued Qty.
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col" style="display:none">Given Qty.
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col" style="display:none">Remaining Qty.
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col">Dose Range
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col">Indication / Titrate To
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col">Route
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col">Duration
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col">Status
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col">EntryBy
                                                </th>
                                            </tr>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr style="text-align: center;" id="trHead" runat="server">
                                            <td class="GridViewItemStyle" style="width: 30px; text-align: left;">
                                                <asp:ImageButton ID="imbShow" runat="server" AlternateText="Show" ImageUrl="~/Images/plus.png"
                                                    CausesValidation="false" CommandArgument='<%# Eval("ItemID")+"#"+Eval("IndentNo") %>' />
                                                <asp:Image ID="imbNewMedicine" runat="server" ImageUrl="~/Images/NewMedicine.png" Height="74px" Visible="false"  />
                                            </td>
                                            <td class="GridViewItemStyle" style="width: 30px;">
                                                <%# Container.ItemIndex+1 %>
                                            </td>
                                            <td class="GridViewItemStyle" style="width: 200px; text-align: left;">
                                                <b>
                                            	<asp:Label ID="lblItemName" runat="server" Text='<%#Eval("ItemName") %>'></asp:Label></b>
                                                <asp:Label ID="lblItemID" runat="server" Text='<%#Eval("ItemID") %>' Visible="false"></asp:Label>
                                                <asp:Label ID="lblIsinhouseMed" runat="server" Text='<%#Eval("IsInHouseMedicine") %>' Visible="false"></asp:Label>
                                                <asp:Label ID="lblIndentNo" runat="server" Text='<%#Eval("IndentNo") %>' Visible="false"></asp:Label>
                                            </td>
                                            <td class="GridViewItemStyle" style="width: 200px;">
                                                <asp:Label ID="lblIssueDate" runat="server" Text='<%#Eval("Date") %>'></asp:Label>
                                            </td>
                                            <td class="GridViewItemStyle" style="width: 100px; display:none; ">
                                                <%# Eval("IssueQty")%>
                                            </td>
                                            <td class="GridViewItemStyle" style="width: 100px; display:none;">
                                                <%# Eval("ReceiveQty")%>
                                            </td>
                                            <td class="GridViewItemStyle" style="width: 50px; display:none;">
                                                <%# Eval("GivenQty")%>
                                            </td>
                                            <td class="GridViewItemStyle" style="width: 50px; display:none;">
                                                <asp:Label ID="lblRemainingQty" runat="server" Text='<%# Eval("RemainingQty")%>'></asp:Label>
                                            </td>
                                            <td class="GridViewItemStyle" style="width: 100px;">
                                                <asp:Label ID="lblDose" runat="server" Text='<%# Eval("Dose")%>'></asp:Label>
                                            </td>
                                            <td class="GridViewItemStyle" style="width: 100px;">
                                                <%# Eval("Timing")%>
                                            </td>
                                              <td class="GridViewItemStyle" style="width: 100px;">
                                                <%# Eval("Route")%>
                                            </td>
                                            <td class="GridViewItemStyle" style="width: 100px;">
                                                <%# Eval("Duration")%>
                                            </td>
                                            <td class="GridViewItemStyle" style="width: 50px; text-align: left;">
                                                <b>
                                                    <asp:Label ID="lblStatus" runat="server" Text='<%#Eval("Status") %>'></asp:Label></b>
                                            </td>
                                            <td class="GridViewItemStyle" style="width: 100px;">
                                                <%# Eval("EName")%>
                                                <asp:ImageButton ID="imgEdit" runat="server" ImageUrl="~/Images/edit.png" AlternateText="Edit"
                                                    CausesValidation="false" CommandArgument='<%# Eval("ItemID")+"#"+Eval("IndentNo")+"#"+Eval("Dose")+"#"+Eval("Timing")+"#"+Eval("Duration") %>' />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="15" style="padding-left: 5px">
                                                <asp:Repeater ID="rptMedicineDetails" runat="server" OnItemCommand="rptMedicineDetails_ItemCommand" OnItemDataBound="rptMedicineDetails_ItemDataBound">
                                                    <HeaderTemplate>
                                                        <table cellpadding="0" cellspacing="0">
                                                            <tr style="width: 100%" runat="server" id="tr1">
                                                                <td colspan="2" style="text-align: left;">MedicineDate:
                                                                </td>
                                                                <td colspan="3">Time:
                                                                </td>
                                                                <td>IV Rate:
                                                                </td>
                                                                <td>Dose:
                                                                </td>
                                                                <td style="display: none">Qty:
                                                                </td>
                                                                <td style="display:none;">DripRate:
                                                                </td>
                                                                <td>Syringe Changed:
                                                                </td>
                                                                <td colspan="2">Syringe Concentration:
                                                                </td>
                                                                <td style="vertical-align: top">Route:
                                                                </td>
                                                                <td style="vertical-align: top;display:none;">Frequency:
                                                                </td>
                                                                <td colspan="2">Comments:
                                                                </td>
                                                                <td></td>
                                                            </tr>
                                                            <tr style="width: 100%" runat="server" id="trMedDetail">
                                                                <td colspan="2" style="text-align: left;"><asp:TextBox ID="txtDate" runat="server" Width="100px"></asp:TextBox>
                                                                    <cc1:CalendarExtender ID="calucDate" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy">
                                                                    </cc1:CalendarExtender>
                                                                </td>
                                                                <td colspan="3"><asp:TextBox ID="txttime" runat="server" Width="60px" CssClass="ItDoseTextinputText"></asp:TextBox>
                                                                    <cc1:MaskedEditExtender ID="masEndTime" Mask="99:99" runat="server" MaskType="Time"
                                                                        TargetControlID="txttime" AcceptAMPM="True">
                                                                    </cc1:MaskedEditExtender>
                                                                    <cc1:MaskedEditValidator ID="maskEndTime" runat="server" ControlToValidate="txttime"
                                                                        ControlExtender="masEndTime" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                                                        InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                                                                </td>
                                                                <td style="width:70px;"><asp:TextBox ID="txtIVRate" runat="server" Width="50px"></asp:TextBox>
                                                                </td>
                                                                
                                                                <td style="width:70px;"><asp:TextBox ID="txtDose" runat="server" Width="50px"></asp:TextBox>
                                                                </td>
                                                                <td style="display:none">
                                                                    <asp:TextBox ID="txtQty" runat="server" Width="50px" CssClass="ItDoseTextinputText" value="1"></asp:TextBox>
                                                                    <cc1:FilteredTextBoxExtender ID="txtQty_FilteredTextBoxExtender" runat="server"
                                                                        FilterType="Numbers" TargetControlID="txtQty">
                                                                    </cc1:FilteredTextBoxExtender>
                                                                </td>
                                                                 <td style="width:70px;display:none;"><asp:TextBox ID="txtDripRate" runat="server" Width="50px"></asp:TextBox>
                                                                </td>
                                                               
                                                                <td>
                                                                <asp:CheckBox ID="chkSyringeChanged" AutoPostBack="false" Text="" runat="server"  style="font-weight: 700"  />
                                                                </td>
                                                                 <td><asp:TextBox ID="txtSyringeContraction" runat="server" Width="50px" CssClass="ItDoseTextinputText"></asp:TextBox>
                                                               </td>
                                                                 <td><asp:DropDownList ID="ddlSyringeContraction" runat="server" Width="100px">
                                                                     <asp:ListItem Value="0">--Select--</asp:ListItem>
                                                                     <asp:ListItem Value="1/4">1/4</asp:ListItem>
                                                                     <asp:ListItem Value="1/2">1/2</asp:ListItem>
                                                                     <asp:ListItem Value="Full">Full</asp:ListItem>
                                                                     <asp:ListItem Value="Double">Double</asp:ListItem>
                                                                     </asp:DropDownList>
                                                            </td>
                                                                 <td >
                                                                 <asp:DropDownList ID="ddlRouteHos" runat="server" Width="100px"></asp:DropDownList>
                                                            </td>
                                                             <td style="display:none;">
                                                                 <asp:DropDownList ID="ddFreHos" runat="server" Width="100px"></asp:DropDownList>
                                                            </td>
                                                                <td colspan="2"><asp:TextBox ID="txtRemark" Width="77%" runat="server"></asp:TextBox>
                                                                </td>
                                                                <td>
                                                                    <asp:Button ID="Button1" runat="server" Text="Save" ForeColor="Blue"
                                                                        Font-Bold="true" />
                                                                </td>
                                                            </tr>
                                                            <tr runat="server" id="trStatus" visible="false">
                                                                <td style="text-align: right;" colspan="12">
                                                                    <asp:RadioButton BackColor="Aqua" ID="rdoStop" runat="server" Text="Stop Medicine" />
                                                                    <asp:Button ID="btnSave" runat="server" Text="Save" ForeColor="Blue"
                                                                        Font-Bold="true" />
                                                                </td>
                                                            </tr>
                                                           <%-- <tr  style="background-color: #7dd95d;">--%>
															<tr  style="background-color: #ffb6c1;">
                                                                <th scope="col">S.No.
                                                                </th>
                                                                <th scope="col">Medicine Date
                                                                </th>
                                                                <th scope="col">Time
                                                                </th>
                                                                <th scope="col">IVRate
                                                                </th>
                                                                <th scope="col">Dose
                                                                </th>
                                                                <th scope="col" style="display:none">Qty
                                                                </th>
                                                                <th scope="col"  style="display:none;">DripRate
                                                                </th>
                                                                <th scope="col">SyringeChanged
                                                                </th>
                                                                <th scope="col" colspan="2">Syringe Concentration
                                                                </th>
                                                                <th scope="col">Route
                                                                </th>
                                                                <th scope="col" style="display:none;">Frequency
                                                                </th>
                                                                <th scope="col">Entry By
                                                                </th>
                                                                <th scope="col">Entry Date & Time
                                                                </th>
                                                                <th scope="col" style="display: none;">Status
                                                                </th>
                                                                <th scope="col">Comments
                                                                </th>
                                                                <th scope="col"></th>
                                                            </tr>
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                       <%-- <tr style="background-color: #7dd95d; text-align: center;">--%>
														<tr style="background-color: #ffb6c1; text-align: center;">
                                                            <td style="width: 150px;">
                                                                <%# Container.ItemIndex+1 %>
                                                            </td>
                                                            <td style="width: 150px;">
                                                                <asp:Label ID="lblDate" runat="server" Text='<%#Eval("DATE") %>'></asp:Label>
                                                            </td>
                                                            <td style="width: 150px;">
                                                                <asp:Label ID="Label1" runat="server" Text='<%#Eval("Time") %>'></asp:Label>
                                                            </td>
                                                            <td style="width: 150px;">
                                                                <asp:Label ID="lblIVRate" runat="server" Text='<%#Eval("IVRate") %>'></asp:Label>
                                                            </td>
                                                            <td style="width: 50px;">
                                                                <asp:Label ID="lblDose" runat="server" Text='<%#Eval("Dose") %>'></asp:Label>
                                                            </td>
                                                            <td style="width: 50px; display:none;">
                                                                <asp:Label ID="lblQty" runat="server" Text='<%#Eval("Qty") %>'></asp:Label>
                                                            </td>
                                                            <td style="width: 50px;display:none;">
                                                                <asp:Label ID="lblDripRate" runat="server" Text='<%#Eval("DripRate") %>'></asp:Label>
                                                            </td>
                                                            <td style="width: 50px;">
                                                                <asp:Label ID="lblSyringeChanged1" runat="server" Text='<%#Eval("SyringeChanged1") %>'></asp:Label>
                                                            </td>
                                                            <td style="width: 50px;">
                                                                <asp:Label ID="lblSyringeContraction" runat="server" Text='<%#Eval("SyringeContraction") %>'></asp:Label>
                                                            </td>
                                                            <td style="width: 50px;">
                                                                <asp:Label ID="lblSyringeContraction1" runat="server" Text='<%#Eval("SyringeContraction1") %>'></asp:Label>
                                                            </td>
                                                            <td style="width: 50px;">
                                                                <asp:Label ID="lblRoute" runat="server" Text='<%#Eval("Route") %>'></asp:Label>
                                                            </td>
                                                            <td style="width: 50px;display:none;">
                                                                <asp:Label ID="Label3" runat="server" Text='<%#Eval("Frequency") %>'></asp:Label>
                                                            </td>
                                                            <td style="width: 250px;">
                                                                <asp:Label ID="lblEntryBy" runat="server" Text='<%#Eval("EntryBy") %>'></asp:Label>
                                                            </td>
                                                            <td style="width: 250px;">
                                                                <asp:Label ID="lblEntryDate" runat="server" Text='<%#Eval("EntryDateTime") %>'></asp:Label>
                                                            </td>
                                                            <td style="width: 250px; display: none;">
                                                                <asp:Label ID="lblStatusType" runat="server" Text='<%#Eval("StatusType") %>' ForeColor="Blue"
                                                                    Font-Bold="true"></asp:Label>
                                                            </td>
                                                            <td style="width: 250px;">
                                                                <asp:Label ID="lblRemark" runat="server" Text='<%#Eval("Remark") %>' ForeColor="Blue"
                                                                    Font-Bold="true"></asp:Label>
                                                            </td>
                                                            <td>
                                                                <asp:ImageButton ID="imbCancel" runat="server" ImageUrl="~/Images/Delete.gif" CommandName="cancel"
                                                                    CausesValidation="false" CommandArgument='<%# Eval("ItemID")+"#"+Eval("IndentNo")+"#"+Eval("TransactionID")+"#"+Eval("ID") %>' />
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
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        
        <table style="width: 100%">
            <tr>
                <td colspan="2">
                    <asp:CheckBox ID="chkOtherMedicne" AutoPostBack="true" Text="Add New Medicine" runat="server" OnCheckedChanged="chkOtherMedicne_CheckedChanged" style="font-weight: 700" />
                </td>
                <td colspan="7" style="display:none">
                     <asp:CheckBox ID="chkInHouse" Text="Is In House Medicine" runat="server" style="font-weight: 700"  Visible="false" />
                
                </td>
            </tr>

            <tr id="trOtherMedicine" runat="server" visible="false">
                <td>Medicine Name : 
                    <asp:TextBox ID="txtOtherMedicine" runat="server"></asp:TextBox>
                </td>
                <td>
                    &nbsp;&nbsp;</td>
                <td style="display:none;">Qty : 
                    <asp:TextBox ID="txtQtyIssued" runat="server" Text="1" ></asp:TextBox> </td>
                <td>
                    &nbsp;&nbsp;
                </td>
                <td>Dose Range : 
                    <asp:TextBox ID="txtDose" runat="server"></asp:TextBox> </td>
                <td>
                    &nbsp;&nbsp;
                </td>
                <td>Indication / Titrate To : 
<%--                    <asp:DropDownList ID="ddlTime" runat="server"></asp:DropDownList>--%>
                    
                    <asp:TextBox ID="txtTime" runat="server"></asp:TextBox>
                </td>
                <td>
                    &nbsp;&nbsp;
                </td>
                <td>Duration : 
                    <asp:DropDownList ID="ddlDuration" runat="server"></asp:DropDownList> </td>
                <td>
                    &nbsp;&nbsp;
                </td>
                <td>Route : 
                    <asp:DropDownList ID="ddlRoute" runat="server"></asp:DropDownList> </td>
                <td>
                    <asp:Button ID="btnOtherMedicine" runat="server" OnClick="btnOtherMedicine_Click" Text="Save Medicine" />
                </td>
            </tr>
        </table>
                    <br />   
        <br />
        <asp:Button ID="btnHidden" runat="server" Style="display: none" />
        <asp:Panel ID="Panel1" runat="server" CssClass="pnlVendorItemsFilter" Width="550px" Style="display: none">
            <div class="Purchaseheader" id="Div1" runat="server">
                Edit Medicine Details
            </div>
            <div class="content" style="margin-left: 10px">
                <table style="width: 530px">
                    <tr>
                        <td style="text-align: right">Dose :
                            <asp:Label ID="lblIndentNo" runat="server" Visible="false"></asp:Label>
                            <asp:Label ID="lblPopItemID" runat="server" Visible="false"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtPopDose" runat="server" Width="80px"></asp:TextBox></td>
                        <td style="text-align: right">Time :</td>
                        <td>
                            <asp:DropDownList ID="ddlPopTimes" runat="server"></asp:DropDownList></td>
                        <td style="text-align: right">Duration :</td>
                        <td>
                            <asp:TextBox ID="txtPopDuration" runat="server" Width="100px"></asp:TextBox>
                            <cc1:CalendarExtender ID="caluctxtPopDuration" runat="server" TargetControlID="txtPopDuration" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="filterOpDiv">
                <asp:Button ID="btnSaveDose" runat="server" CssClass="ItDoseButton" Text="Save" OnClick="btnSaveDose_Click" />&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btncancel" runat="server" CssClass="ItDoseButton" Text="Close"
                CausesValidation="false" />&nbsp;
            </div>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpDose" runat="server" CancelControlID="btncancel"
            DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
            PopupControlID="Panel1" PopupDragHandleControlID="Div1">
        </cc1:ModalPopupExtender>
    </form>
</body>
</html>