<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PatientAssignmentDesk.aspx.cs" Inherits="Design_IPD_PatientAssignmentDesk" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="../../Scripts/jquery.blockUI.js" type="text/javascript"></script>

    <script type="text/javascript">
        function BlockUI(elementID) {
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_beginRequest(function () {
                $("#" + elementID).block({
                    message: '<table align = "center"><tr><td>' +
                        '<img src="../../Images/loadingAnim.gif"/></td></tr></table>',
                    css: {},
                    overlayCSS: {
                        backgroundColor: '#000000', opacity: 0.6
                    }
                });
            });
            prm.add_endRequest(function () {
                $("#" + elementID).unblock();
            });
        }
        $(document).ready(function () {
            BlockUI("div1");
            $.blockUI.defaults.css = {};
        });

        var OpenDivSearchModel = function (e) {
            e.preventDefault();
            var divSearchbyDate = $('#divSearchbyDate');
            divSearchbyDate.showModel();
        }
        var CloseDivSearchModel = function () {
            $('#divSearchbyDate').closeModel();
        }
    </script>

    <div id="Pbody_box_inventory" ">
        <div class="row">
            <div class="col-md-24">
                <div class="row">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div style="text-align: center;">
            <div class="row">
            <div class="col-md-21" >
            <strong><span style="font-size: 25pt">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:: Patient Assignment Desk ::</span></strong></div>
            <div class="col-md-3" >
                <asp:Button ID="btnExport" Text="Export" runat="server" OnClientClick="OpenDivSearchModel(event);"/>
            </div>
            </div>
        </div>
                <div runat="server" id="div1">
                    <asp:GridView Width="100%" ID="grdDischargeScreen" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" ShowFooter="True" OnRowCommand="grdDischargeScreen_RowCommand">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>                         
                            <asp:TemplateField HeaderText="UHID" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:Label ID="UHID" runat="server" Text='<%#Util.GetString(Eval("UHID")) %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                            <asp:TemplateField HeaderText="IPD No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:Label ID="IPDNo" runat="server" Text='<%#Util.GetString(Eval("IPDNo")) %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                          <asp:TemplateField HeaderText="Patient Name" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:Label ID="PatientName" runat="server" Text='<%#Util.GetString(Eval("PatientName")) %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                          <asp:TemplateField HeaderText="Contact No" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:Label ID="ContactNo" runat="server" Text='<%#Util.GetString(Eval("ContactNo")) %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                         <asp:TemplateField HeaderText="Bed/Ward" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:Label ID="DateOfDischarge" runat="server" Text='<%#Util.GetString(Eval("BedCategory")) %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                         <asp:TemplateField HeaderText="Doctor Name" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:Label ID="DoctorName" runat="server" Text='<%#Util.GetString(Eval("DoctorName")) %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="Panel" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:Label ID="Panel" runat="server" Text='<%#Util.GetString(Eval("Panel")) %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                            <asp:TemplateField HeaderText="Procedure</br> Advice" >
                                <ItemTemplate>
                                    <asp:ImageButton ID="imgRoomClearnaceRed1" CausesValidation="False" CommandName="ProcedureCall" CssClass="blink"  Width="30px" Height="30px"   runat="server" ImageUrl="~/Images/Greenstatus.png" CommandArgument='<%# Eval("TransactionID") %>' Visible='<%# Util.GetBoolean(Eval("ProcedureCount")) %>' />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Font-Bold="True" Width="60px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Font-Bold="True" Width="60px" />
                            </asp:TemplateField>
                               <asp:TemplateField HeaderText="Medicine</br> Advice" >
                                <ItemTemplate>
                                    <asp:ImageButton ID="imgRoomClearnaceRed2" CausesValidation="False" CommandName="MedicineCall" CssClass="blink"  Width="30px" Height="30px"   runat="server" ImageUrl="~/Images/Greenstatus.png" CommandArgument='<%# Eval("TransactionID") %>' Visible='<%# Util.GetBoolean(Eval("MedicineCount")) %>' />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Font-Bold="True" Width="60px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Font-Bold="True" Width="60px" />
                            </asp:TemplateField>
                               <asp:TemplateField HeaderText="Investigation</br> Advice" >
                                <ItemTemplate>
                                    <asp:ImageButton ID="imgRoomClearnaceRed3" CausesValidation="False" CommandName="InvestigationCall" CssClass="blink"  Width="30px" Height="30px"   runat="server" ImageUrl="~/Images/Greenstatus.png" CommandArgument='<%# Eval("TransactionID") %>' Visible='<%# Util.GetBoolean(Eval("InvestigationCount")) %>' />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Font-Bold="True" Width="60px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Font-Bold="True" Width="60px" />
                            </asp:TemplateField>
                               <asp:TemplateField HeaderText="Other</br> Advice" >
                                <ItemTemplate>
                                    <asp:ImageButton ID="imgRoomClearnaceRed4" CausesValidation="False" CommandName="OtherCall" CssClass="blink"  Width="30px" Height="30px"   runat="server" ImageUrl="~/Images/Greenstatus.png" CommandArgument='<%# Eval("TransactionID") %>' Visible='<%# Util.GetBoolean(Eval("OtherCount")) %>' />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Font-Bold="True" Width="60px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Font-Bold="True" Width="60px" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
                    </div>
                </div>
            </div>
    </div>
     <style type="text/css">
         .blink {
             animation: blinker-two 1.6s linear infinite;
         }

         @keyframes blinker-two {
             100% {
                 opacity: 0;
             }
         }
     </style>
    <div id="divSearchbyDate" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="min-width:200px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divSearchbyDate" area-hidden="true">&times;</button>
                    <b class="modal-title">Search By Discharge Date</b>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                            <div class="row">
                                <div class="col-md-5">
                                    <label class="pull-left">From Date</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-7">
                                    <asp:TextBox ID="ucFromDate" runat="server" ToolTip="Click To Select From Date" ClientIDMode="Static" TabIndex="1"></asp:TextBox>
				            		<cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                                </div>
                                <div class="col-md-4">
                                    <label class="pull-left">To Date</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <asp:TextBox ID="ucToDate" runat="server" ClientIDMode="Static" TabIndex="2" ToolTip="Click To Select To Date"></asp:TextBox>
						            <cc1:CalendarExtender ID="fc2" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-1"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" CssClass="ItDoseButton" />
    </div>
       <asp:Panel ID="Panel1" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none">
        <div class="Purchaseheader" id="Div2" runat="server">
            Update status
        </div>
           <div class="content" style="margin-left: 10px">
               <table style="width: 476px">
                   <tr>
                       <td style="width: 66px">IPD No. :
                           <asp:Label ID="lblIPDNo" runat="server" CssClass="ItDoseLabelSp" />
                       </td>
                       <td >
                           
                           <asp:Label ID="lblCategory" Visible="false" runat="server" CssClass="ItDoseLabelSp" />
                       </td>
                   </tr>
                   <tr>
                       <td>
                           <div style="height: 280px; width: 450px; overflow-y: auto; display: block;">
                           <asp:GridView ID="grditems" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False" Width="100%" >
                               <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                               <Columns>
                                   <asp:TemplateField HeaderText="S.No.">
                                       <ItemTemplate>
                                           <%# Container.DataItemIndex+1 %>
                                       </ItemTemplate>
                                       <ItemStyle CssClass="GridViewItemStyle" />
                                       <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                   </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Service Name">
                                       <ItemTemplate>
                                           <asp:Label ID="lblServiceName" Width="350px" runat="server" Text='<%#Util.GetString(Eval("ItemName")) %>'></asp:Label>
                                       </ItemTemplate>
                                       <ItemStyle CssClass="GridViewItemStyle" />
                                       <HeaderStyle CssClass="GridViewHeaderStyle" Width="350px" />
                                   </asp:TemplateField>
                               </Columns>
                           </asp:GridView>
                               </div>
                       </td>
                   </tr>
               </table>
           </div>
        <div class="filterOpDiv">
            <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" Text="Update Status" OnClick="btnSave_Click"/>&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnItemCancel" runat="server" CssClass="ItDoseButton" Text="Cancel"
                CausesValidation="false" />&nbsp;
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpCancel" runat="server" CancelControlID="btnItemCancel"
        DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
        PopupControlID="Panel1" PopupDragHandleControlID="Div2">
    </cc1:ModalPopupExtender>
</asp:Content>

