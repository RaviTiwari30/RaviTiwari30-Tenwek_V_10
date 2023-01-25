<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RoomSiftingIPDRequest.aspx.cs" Inherits="Design_IPD_RoomSiftingIPDRequest" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Src="~/Design/Controls/StartDateTime.ascx" TagName="StartDate" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Room Billing</title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src ="../../Scripts/jquery-1.7.1.min.js"></script>
    <link rel="Stylesheet"  type="text/css" href="../../Scripts/chosen.css"/>
     <script type="text/javascript" src="../../Scripts/chosen.jquery.js"></script>
    <script type ="text/javascript" >
        $(document).ready(function () {
            $('.ddlsearchable').chosen();
        });
        function RestrictDoubleEntry(btn) {
            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('btnShift', '');
        }
        function validate() {
            if ($("#txtCancelReason").val() == "") {
                $("#lblmsgpopup").text('Please Enter Cancel Reason');
                $("#txtCancelReason").focus();
                return false;
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find("mpDetail")) {
                    $find("mpDetail").hide();

                }
            }

        }
        function closeDetail() {
            if ($find("mpDetail")) {
                $find("mpDetail").hide();
                $("#txtCancelReason").val('');
            }
        }

    </script>
    
</head>
<body>
    <form id="form1" runat="server">
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">           
                <b>Patient Room Shifting Request</b>
                <br />
                <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError" />          
        </div>
        <asp:Panel ID="pnlPatient" runat="server">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Current Information
                </div>
               
                    <table  style="width: 100%;border-collapse:collapse">
                        <tr>
                            <td  style="width: 15%;text-align:right">
                                Room Type :&nbsp;
                            </td>
                            <td  style="width: 35%;text-align:left">
                                <asp:Label ID="lblCurRoomCat" runat="server" CssClass="ItDoseLabelSp" />
                            </td>
                            <td  style="width: 20%;text-align:right">
                                Billing Type :&nbsp;
                            </td>
                            <td style="width: 30%;text-align:left">
                                <asp:Label ID="lblCurBillCat" runat="server" CssClass="ItDoseLabelSp" />
                            </td>
                        </tr>
                        <tr>
                            <td  style="width: 15%;text-align:right">
                                Room :&nbsp;
                            </td>
                            <td  style="width: 35%;text-align:left">
                                <asp:Label ID="lblCurRoom" runat="server" CssClass="ItDoseLabelSp" />
                            </td>
                            <td  style="width: 20%;text-align:right">
                                Admitted/Shifted On :&nbsp;
                            </td>
                            <td  style="width: 30%;text-align:left">
                                <asp:Label ID="lblShiftDate" runat="server" CssClass="ItDoseLabelSp" />
                            </td>
                        </tr>
                    </table>
                
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Update Information
                </div>
               
                    <table  style="width: 100%;border-collapse:collapse">
                        <tr>
                           <td  style="width: 15%;text-align:right">
                                Room Type :&nbsp;
                            </td>
                             <td  style="width: 35%;text-align:left">
                                <asp:DropDownList ID="cmbRoomType" runat="server" OnSelectedIndexChanged="cmbRoomType_SelectedIndexChanged" ClientIDMode="Static" CssClass="ddlsearchable"
                                    AutoPostBack="True" Width="250px" />
                            </td>
                            <td  style="width: 15%;text-align:right">
                                Billing Type :&nbsp;
                            </td>
                             <td  style="width: 35%;text-align:left">
                                <asp:DropDownList ID="ddlBillCategory" runat="server" Width="250px" ClientIDMode="Static" CssClass="ddlsearchable" />
                            </td>
                          
                        </tr>
                        <tr>
                            <td  style="width: 15%;text-align:right">
                                Available Room :&nbsp;
                            </td>
                            <td  style="width: 35%;text-align:left">
                                <asp:DropDownList ID="cmbAvailRooms" runat="server" Width="250px" ClientIDMode="Static" CssClass="ddlsearchable" />
                                <span class="shat" style="color: red; font-size: 10px;">*</span></td>
                           <td  style="width: 15%;text-align:right">
                                Shift Date Time :&nbsp;
                            </td>
                            <td  style="width: 35%;text-align:left">
                                <uc1:StartDate ID="txtDate" runat="server" />
                            </td>
                           
                        </tr>
                        <tr>
                             <td  style="width: 15%;text-align:right">
                                Requisition Status :&nbsp;
                            </td>
                            <td  style="width: 35%;text-align:left">
                                <asp:DropDownList runat="server" ID="rbtSample" Width="250px" ClientIDMode="Static" OnSelectedIndexChanged="rbtSample_SelectedIndexChanged" AutoPostBack="true">
                                    <asp:ListItem Value="P">Pending</asp:ListItem>
                                    <asp:ListItem Value="A">Shifted</asp:ListItem>
                                    <asp:ListItem Value="C">Cancelled</asp:ListItem>                              
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                
            </div>
            <div class="POuter_Box_Inventory">
                <div class="content" style="text-align: center;">
                     <asp:Button ID="btnRoomRequest" runat="server" CssClass="ItDoseButton" Text="Save Room Request" OnClick="btnRoomRequest_Click"                        
                    Enabled="False" />
                   <%-- <asp:Button ID="btnShift" runat="server" CssClass="ItDoseButton" Text="Shift" OnClick="btnShift_Click"
                        Enabled="False" OnClientClick="RestrictDoubleEntry(this)" />--%>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; <span style="background-color: #99FFCC">
                        Status In</span>&nbsp;&nbsp;<span style="background-color: #FF99CC">Status Out</span>
                </div>
            </div>

               <div class="POuter_Box_Inventory" style="text-align: center">
                <div class="Purchaseheader">
                    Requisition Details
                </div>
                <div class="content" style="text-align: center;overflow-y:scroll;height:150px;width:99%">
                    <asp:GridView ID="grdRequestSearch" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle" OnSelectedIndexChanged="grdRequestSearch_SelectedIndexChanged"
                         OnRowDataBound="grdRequestSearch_RowDataBound" Width="99%">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="IPDNo" HeaderText="IPD No." HeaderStyle-Width="60px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle" />
                            <asp:BoundField DataField="MRNo" HeaderText="UHID" HeaderStyle-Width="60px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle" />
                            <asp:BoundField DataField="PName" HeaderText="Patient Name" HeaderStyle-Width="120px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle" />
                            <asp:BoundField DataField="CurrentRoomType" HeaderText="Current Room" HeaderStyle-Width="90px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                            <asp:BoundField DataField="CurrentRoom" HeaderText="Current Room" HeaderStyle-Width="60px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle" />
                            <asp:BoundField DataField="RequestedRoomType" HeaderText="Req. Room Type" HeaderStyle-Width="130px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle"
                                Visible="false" />
                            <asp:BoundField DataField="RequestedRoom" HeaderText="Requested Room" HeaderStyle-Width="170px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                            <asp:BoundField DataField="RequestTime" HeaderText="Request For DateTime" HeaderStyle-Width="170px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                            <asp:BoundField DataField="RequestedBy" HeaderText="Requested By" HeaderStyle-Width="140px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />                      
                            <asp:CommandField HeaderText="Cancel" ButtonType="Image"  HeaderStyle-Width="50px" ShowSelectButton="true"
                            SelectImageUrl="~/Images/delete.gif">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:CommandField>
                            <asp:BoundField DataField="Remarks" HeaderText="Reason" HeaderStyle-Width="140px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                            <asp:TemplateField HeaderText="CanReject" Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="lblCanReject" runat="server" Text='<%# Util.GetString( Eval("CanReject")) %>'></asp:Label>
                                    </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                             </asp:TemplateField> 
                                                 
                        </Columns>
                    </asp:GridView>
                </div>
        <cc1:ModalPopupExtender ID="mpDetail" runat="server" CancelControlID="btnClose"
                TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground" PopupControlID="pnlDetail"
                X="250" Y="150" BehaviorID="mpDetail">
            </cc1:ModalPopupExtender>
            <div style="display: none;">
                <asp:Button ID="btnHidden" runat="server" Text="Button" CssClass="ItDoseButton" />
            </div>
        <asp:Panel ID="pnlDetail" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none; width: 540px"> 
            <div class="Purchaseheader">
            Cancel
            <em><span style="font-size: 7.5pt;float:right" class="shat">Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor: pointer" alt="" onclick="closeDetail()" />
                to close</span></em>
             </div>
        <table style="width: 100%; border-collapse: collapse">
            <tr>
                <td style="text-align: center" colspan="4">
                    <asp:Label ID="lblmsgpopup" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="vertical-align: top; text-align: right; width: 20%">Enter Reason :&nbsp;
                </td>
                <td style="vertical-align: top; text-align: left; width: 80%" colspan="3">
                    <asp:TextBox ID="txtCancelReason" ToolTip="Enter Cancel Reason" runat="server" TextMode="MultiLine" Width="400px"></asp:TextBox>
                    <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                </td>
            </tr>
        </table>
        <div class="filterOpDiv">
            <asp:Button ID="btnCancel" runat="server" Text="Save" CssClass="ItDoseButton"
                ToolTip="Click to Cancel" OnClick="btnCancel_Click" OnClientClick="return validate();" />
            &nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnClose" runat="server" Text="Cancel" CausesValidation="false"
                CssClass="ItDoseButton" ToolTip="Click to Cancel" />&nbsp;
        </div>
        </asp:Panel>

             <div class="POuter_Box_Inventory" style="display:none">
               <div style="text-align: center; padding-top: 5px;">
                  <asp:Button ID="btnShift" runat="server" CssClass="ItDoseButton" Text="Shift" OnClick="btnShift_Click"
                        Enabled="False" OnClientClick="RestrictDoubleEntry(this)" />
               </div>
            </div>
            </div>

            <div class="POuter_Box_Inventory" style="text-align: center">
                <div class="Purchaseheader">
                    Room Shift Details
                </div>
                <div class="content" style="text-align: center;overflow-y:scroll;height:300px;width:99%">
                    <asp:GridView ID="grdRoomDetail" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle"
                        OnRowDataBound="grdRoomDetail_RowDataBound"  Width="99%">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="IPDNo" HeaderText="IPD No." HeaderStyle-Width="60px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle" />
                            <asp:BoundField DataField="MRNo" HeaderText="UHID" HeaderStyle-Width="60px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle" />
                            <asp:BoundField DataField="PName" HeaderText="Patient Name" HeaderStyle-Width="120px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle" />
                            <asp:BoundField DataField="RoomType" HeaderText="Room Type" HeaderStyle-Width="90px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                            <asp:BoundField DataField="Room" HeaderText="Room" HeaderStyle-Width="60px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle" />
                            <asp:BoundField DataField="BillingCategory" HeaderText="Billing Category" HeaderStyle-Width="130px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle"
                                Visible="false" />
                            <asp:BoundField DataField="EntryDate" HeaderText="Entry Date" HeaderStyle-Width="170px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                            <asp:BoundField DataField="LeaveDate" HeaderText="Leave Date" HeaderStyle-Width="170px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                            <asp:BoundField DataField="Name" HeaderText="Shifted By" HeaderStyle-Width="140px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                            <asp:TemplateField HeaderText="Status" HeaderStyle-Width="70px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("Status") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView></div>
               
            </div>
            <asp:Label ID="lblPanel_ID" runat="server" Visible="False"></asp:Label>
            <asp:Label ID="lblPatientID" runat="server" Visible="False"></asp:Label>
            <asp:Label ID="lblTransactionNo" runat="server" Visible="False"></asp:Label>
            <asp:Label ID="lblRoom_ID" runat="server" Visible="False"></asp:Label>
            <asp:Label ID="lbl" runat="server" Visible="False"></asp:Label>
             <asp:Label ID="lblDoctorID" runat="server" Visible="False"></asp:Label>
        </asp:Panel>
    </div>
    </form>
</body>
</html>
