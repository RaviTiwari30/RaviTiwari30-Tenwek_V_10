<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BillNotFinalisedList.aspx.cs"
    Inherits="Design_IPD_BillNotFinalisedList" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory" >
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
                <b>Patient Discharged But Bill Not Finalised</b>&nbsp;<br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                <br />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
                <asp:RadioButtonList ID="rbtFilter" runat="server" AutoPostBack="True" OnSelectedIndexChanged="rbtFilter_SelectedIndexChanged"
                    RepeatDirection="Horizontal">
                    <asp:ListItem Value="0">Bill Pending Approval</asp:ListItem>
                    <asp:ListItem Value="1">Bill Not Generated</asp:ListItem>
                    <asp:ListItem Selected="True" Value="2">Both</asp:ListItem>
                </asp:RadioButtonList>
                <asp:Button ID="btnExport" runat="server" CssClass="ItDoseButton" OnClick="btnExport_Click"
                    Text="Export Data" Visible="False" Width="122px" /></div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria
            </div>
            <div class="content">
                <asp:GridView ID="grdPatient" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" Width="914px">
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No.">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="15px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="UHID">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        <ItemTemplate>
                                            <asp:Label ID="lblMRNo" runat="server" Text='<%#Eval("MRNo") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="IPD No.">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        <ItemTemplate>
                                            <asp:Label ID="lblTransactionID" runat="server" Text='<%#Eval("IPDNo") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                     <asp:BoundField DataField="BedNo" HeaderText="Bed No.">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="RoomType" HeaderText="Room Type">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                   
                                    <asp:TemplateField HeaderText="Admit Date Time" HeaderStyle-Width="100px">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        <ItemTemplate>
                                            <asp:Label ID="lbldate" runat="server" Text='<%#  Eval("AdmitDateTime") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Discharge Date Time">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        <ItemTemplate>
                                            <asp:Label ID="lblDischargeDate" runat="server" Text='<%#  Eval("DischargeDateTime") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Discharge By">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        <ItemTemplate>
                                            <asp:Label ID="lblDischargedBy" runat="server" Text='<%#  Eval("DischargBy") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                     <asp:BoundField DataField="DoctorName" HeaderText="Doctor Name">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    
                                    <asp:TemplateField HeaderText="Patient Name">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        <ItemTemplate>
                                            <asp:Label ID="lblPName" runat="server" Text='<%# Eval("PatientName") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Age">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left"  Width="90px"/>
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        <ItemTemplate>
                                            <asp:Label ID="lblAge" runat="server" Text='<%# Eval("Age")  %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Sex">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left"  Width="90px"/>
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        <ItemTemplate>
                                            <asp:Label ID="lblGender" runat="server" Text='<%# Eval("Sex") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Contact No.">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        <ItemTemplate>
                                            <asp:Label ID="lblContact" runat="server" Text='<%#  Eval("ContactNo") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    
                                   
                                    <asp:BoundField DataField="Panel" HeaderText="Panel">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="BillAmt" HeaderText="Bill Amt.">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Deposit" HeaderText="Deposit">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Balance" HeaderText="Balance">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Status" HeaderText="Status">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    <%-- <asp:BoundField DataField="BillNo" HeaderText="BillNo">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="BillDate" HeaderText="BillDate">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>--%>
                                </Columns>
                                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            </asp:GridView>              
            </div>
        </div>
    </div>
</asp:Content>
