<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="BedDetails.aspx.cs" Inherits="Design_MIS_BedDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     <link rel="Stylesheet" href="../../Scripts/fancybox/jquery.fancybox-1.3.4.css" type="text/css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox-1.3.4.pack.js"></script>
    <script type="text/javascript">
      
            function showuploadbox(obj,href, maxh, maxw, w, h) {
                //if (obj != "") {
                //    $.fancybox({
                //        maxWidth: maxw,
                //        maxHeight: maxh,
                //        fitToView: false,
                //        width: w,
                //        href: href,
                //        height: h,
                //        autoSize: false,
                //        closeClick: false,
                //        openEffect: 'none',
                //        closeEffect: 'none',
                //        'type': 'iframe'
                //    });
                //}
                if (obj != "") {
                    window.open(href);
                }
            }
        
    </script>
    <div id="Pbody_box_inventory">
         <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Bed Management Detail</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>

        <div class="POuter_Box_Inventory" style="font-weight:700;">
           <div class="row">
               <div class="col-md-24">
                   <div class="row">                       
                        <div class="col-md-4">
                            <label class="pull-left" title="TB">Total Bed&nbsp; (TB)</label>
			                <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                             <asp:Label ID="lblTRoom" runat="server" Width="61px"></asp:Label>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left" title="OB" >Occupied Bed&nbsp; </label><label class="pull-left" title="OB" style="background-color: #F9966B">(OB)</label>
			                <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                             <asp:Label ID="lblORoom" runat="server" ></asp:Label>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left" title="AB" >Available Bed&nbsp; </label><label class="pull-left" title="AB" style="background-color: #6AFB92">(AB)</label>
			                <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                             <asp:Label ID="lblARoom" runat="server"></asp:Label>
                        </div>
                      <div class="col-md-4">
                            <label class="pull-left">Floor</label>
			                <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                             <asp:DropDownList ID="ddlFloor" BackColor="PaleGoldenrod" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlFloor_SelectedIndexChanged"></asp:DropDownList>
                        </div>
                   </div>
                </div>
            </div>
            
            <div class="row" style="display:none">
               <div class="col-md-24" >
                   <div class="row">                       
                        <div class="col-md-4">
                            <label class="pull-left" title="RR" >Requested Room&nbsp; </label><label class="pull-left" title="RR" style="background-color: #FFC0CB">(RR)</label>
			                <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                             <asp:Label ID="lblRRoom" runat="server"></asp:Label>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left" title="ER" >Empty Room&nbsp; </label><label class="pull-left" title="ER" style="background-color: #FFFF00">(ER)</label>
			                <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                             <asp:Label ID="lblTotalDischarge" runat="server"></asp:Label>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left" title="AR">Attender Room&nbsp; </label><label class="pull-left" title="AR" style="background-color: #C0C0C0">(AR)</label>
			                <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                             <asp:Label ID="lblAttenderRoom" runat="server"></asp:Label>
                        </div>
                       <div class="col-md-4">
                            <label class="pull-left" title="RNC" >Room Not Cleaned&nbsp; </label><label class="pull-left" title="RNC" style="background-color: #FF0000">(RNC)</label>
			                <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                             <asp:Label ID="lblNCRoom" runat="server"></asp:Label>
                        </div>                      
                   </div>
                </div>
            </div>
            <div>
                <div class="col-md-24" >
                    <div class="row"> 
                        <div class="col-md-4">
                            <label class="pull-left" title="DIN" >Discharge Intimate&nbsp; </label>
			                <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2" style="background-color:orange; height:16px; width:40px;">
                             
                        </div> 
                     </div>
                 </div>
            </div>          
        </div>

        
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Bed Details
            </div>
            <div>
                <asp:Repeater ID="rpFloor" runat="server" OnItemDataBound="rpFloor_ItemDataBound">
                    <HeaderTemplate>
                        <table class="GridViewItemStyle" cellspacing="0" style="border-collapse: collapse;">
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr style="text-align: center;">
                            <td class="GridViewHeaderStyle">
                                <asp:Label ID="lblFloor" Font-Bold="true" runat="server" Text='<%# Eval("Floor")%>' />
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: left; background-color: #E0FFFF;">
                                <asp:Repeater ID="rpBD" runat="server" OnItemDataBound="rpBD_ItemDataBound">
                                    <HeaderTemplate>
                                        <table cellspacing="0" style="border-collapse: collapse;">
                                            <tr style="text-align: center;">
                                                <th scope="col" class="GridViewStyle">Type</th>
                                                <th scope="col" class="GridViewStyle">Detail</th>
                                                <th scope="col" class="GridViewStyle">TB</th>
                                                <th scope="col" class="GridViewStyle">OB</th>
                                                <%--<th scope="col" class="GridViewStyle">NC</th>--%>
                                                <th scope="col" class="GridViewStyle">AB</span></th>
                                                <th scope="col" class="GridViewStyle">
                                                    <span style="background-color: #F9966B">Occp %</span></th>
                                                <%--<th scope="col" class="GridViewStyle">
                                                    <span style="background-color: #FF0000">RNC % </span></th>--%>
                                                <th scope="col" class="GridViewStyle">
                                                    <span style="background-color: #6AFB92">Avail % </span></th>
                                            </tr>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr>
                                            <td style="width: 130px; color: #800080; border: solid 1px gray; text-align: center; background: <%# Eval("StCol") %>;">
                                                <div style="width: 100%,height:100%; text-align: center; cursor: <%# Eval("Status") %>;" title='<%# Eval("BedRequests") %>'>
                                                    <%# Eval("Name")%>
                                                </div>
                                            </td>
                                            <td style="border: solid 1px gray; text-align: center; width: 900px; vertical-align:middle;">
                                                <asp:DataList ID="dlRoom" runat="server" RepeatDirection="horizontal" RepeatColumns="10">                                                    
                                                    <ItemTemplate>
                                                        <div style="width: 90px;height:35px; cursor: <%# Eval("Status") %>; background: <%# Eval("StCol") %>;"
                                                            title='<%# Eval("PDetails") %>' onclick="showuploadbox('<%# Eval("PatientID") %>','../IPD/OutsideipdFolder.aspx?App_ID=&amp;TID=<%# Eval("transactionid") %>&amp;BillNo=<%# Eval("BillNo") %>&amp;PID=<%# Eval("PatientID") %>&amp;LoginType=<%# Eval("LoginType") %>&amp;BillNo=<%# Eval("BillNo") %>&amp;sex=<%# Eval("Gender") %>&amp;PanelID=<%# Eval("Panelid") %>&amp;DoctorID=<%# Eval("doctorID") %>', 1460, 1320, '100%', '100%');">
                                                            <%# Eval("RoomName")%>
                                                        </div>
                                                    </ItemTemplate>
                                                </asp:DataList>
                                            </td>
                                            <td class="ItDoseLabelSp" style="width: 20px; border: solid 1px gray; text-align: center;">
                                                <asp:Label ID="lblRoomType" runat="server" Text='<%# Eval("IPDCaseType_ID")%>' Visible="false" />
                                                <%# Eval("TRoom")%>
                                            </td>
                                            <td class="ItDoseLabelSp" style="width: 20px; border: solid 1px gray; text-align: center;">
                                                <%# Eval("ORoom")%>
                                            </td>
                                            <%--<td class="ItDoseLabelSp" style="width: 20px; border: solid 1px gray; text-align: center;">
                                                      <%# Eval("NCRoom")%>--%>
                                            </td>
                                            <td class="ItDoseLabelSp" style="width: 20px; border: solid 1px gray; text-align: center;">
                                                <%# Eval("ARoom")%>
                                            </td>
                                            <td class="ItDoseLblError" style="width: 45px; color: Black; background-color: #F9966B; border: solid 1px gray; text-align: right;">
                                                <span style="background-color: #F9966B"><%# Eval("OPer")%></span>
                                            </td>
                                           <%--  <td class="ItDoseLblError" style="width: 45px; color: Black; background-color: #FF0000; border: solid 1px gray; text-align: right;">
                                                <span style="background-color: #FF0000"><%# Eval("NCPer")%></span>--%>
                                            </td>
                                            <td class="ItDoseLblError" style="width: 45px; color: Black; background-color: #6AFB92; border: solid 1px gray; text-align: right;">
                                                <span style="background-color: #6AFB92"><%# Eval("APer")%></span>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <tr style="background-color: #afeeee;">
                                            <td style="text-align: center;" colspan="5">
                                                <asp:Label ID="lblTotal" runat="server" Font-Bold="true" CssClass="ItDoseLabelSp" />
                                            </td>
                                        </tr>
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
            </div>
        </div>
    </div>
</asp:Content>
