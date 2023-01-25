<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Panelallocation_OPD.aspx.cs" Inherits="Design_OPD_Panelallocation_OPD" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
        <link rel="Stylesheet" href="../../Scripts/fancybox/jquery.fancybox-1.3.4.css" type="text/css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox-1.3.4.pack.js"></script>
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.mousewheel-3.0.4.pack.js"></script>

   

    <div id="Pbody_box_inventory">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div style="text-align:center"><b>OPD Panel Allocation</b></div>
        </div>
        <div class="POuter_Box_Inventory">
            
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Bill No</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtBillNo" runat="server" AutoCompleteType="Disabled"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">UHID</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtUHID" runat="server" AutoCompleteType="Disabled"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Name</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtName" runat="server" AutoCompleteType="Disabled"></asp:TextBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">From Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="ucFromDate" runat="server" ToolTip="Click To Select From Date" ClientIDMode="Static" TabIndex="1"></asp:TextBox>
                    <cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">To Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="ucToDate" runat="server" ClientIDMode="Static" TabIndex="2" ToolTip="Click To Select To Date"></asp:TextBox>
                    <cc1:CalendarExtender ID="fc2" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
            </div>
            <div class="row">
                <div class="col-md-24" style="text-align: center;">
                    <asp:Button runat="server" ID="btnSearch" OnClick="btnSearch_Click" Text="Search" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Details
            </div>
            <div style="overflow:scroll; height:inherit;">
            <asp:GridView ID="grdDetails" runat="server" CssClass="GridViewStyle" Width="100%" AutoGenerateColumns="False">
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>
                    <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <%#Container.DataItemIndex+1 %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="PatientID" HeaderText="UHID">
                        <ItemStyle Width="100px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Pname" HeaderText="Name">
                        <ItemStyle Width="100px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="BillNo" HeaderText="Bill No">
                        <ItemStyle Width="100px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Mobile" HeaderText="Mobile">
                        <ItemStyle Width="100px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Age" HeaderText="Age">
                        <ItemStyle Width="100px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Gender" HeaderText="Gender">
                        <ItemStyle Width="100px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="DateOfVisit" HeaderText="Date Of Visit">
                        <ItemStyle Width="100px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Company_Name" HeaderText="Insurance Name">
                        <ItemStyle Width="100px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="Select">
                        <ItemTemplate>
                                <img alt="Select" src="../../Images/Post.gif" style="border: 0px solid #FFFFFF;" onclick="ReseizeIframe('<%#Eval("TransactionID")%>','<%#Eval("PatientID") %>','<%#Eval("Gender") %>')" />
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                        <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>

            </div>
        </div>     
    </div>
    <script type="text/javascript">
        function ReseizeIframe(TID, PID, Gender) {

            serverCall('Panelallocation_OPD.aspx/CheckDataFinance', {TID:TID}, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status)
                { modelAlert(responseData.message); }

                else {

                    var href = "../IPD/PanelAmountAllocation.aspx?TID=" + TID + "&TransactionID=" + TID + "&App_ID=&PID=" + PID + "&PatientId=" + PID + "&Sex=" + Gender + "&IsIPDData=0&AdmissionType=OPD_Al"
                    showuploadbox(href, 1400, 1360, '100%', '100%');
                }
            });
            
        }
        function showuploadbox(href, maxh, maxw, w, h) {
            $.fancybox({
                maxWidth: maxw,
                maxHeight: maxh,
                fitToView: false,
                width: w,
                href: href,
                height: h,
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            });
        }
    </script>
</asp:Content>

