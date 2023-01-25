<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="ConsignmentReturn.aspx.cs" Inherits="Design_Consignment_ConsignmentReturn" %>
<%@ Register Src="~/Design/Purchase/EntryDate.ascx" TagName="EntryDate" TagPrefix="uc1" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
 <%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">

<script type="text/javascript">


function funReturnNo(returnNo)
{
    alert("ReturnNo: " + returnNo);
    ReturnReport(returnNo);//
}

function ReturnReport(returnNo) {
    window.open("ConsignmentReturnReport.aspx?ReturnNo=" + returnNo);
}


 function valdt()
 {
 var gv=document.getElementById('<%=consignmentReturnSearch.ClientID %>');
var grdlngth=gv.rows.length;
   for(var j=1; j<=grdlngth-1; j++)
       {
       var obj=((gv.rows[j].cells[1]).firstChild.checked);
       if(obj==true)
       {
    var retrnQtyctrl=gv.rows[j].cells[9].firstChild;
    var retrnQty=retrnQtyctrl.value;
    var cellReason=gv.rows[j].cells[10].firstChild.value;
     var cellgatepass=gv.rows[j].cells[11].firstChild.value;
     
     if(retrnQty=="0" || retrnQty=="" ||cellReason=="" ||cellgatepass=="")
              {
                 alert("Unexpected/Blank value can't be inserted...!");
                    return false;

         
           }
           else
           {
           return true;
           }
                 }     
       }
 }


function cal(){
 var totals;
     var rowundrGrid;
     var idofchkbx;
     var cntTotalRow='';
var ConcatVal='';
       var c = document.getElementById('<%=consignmentReturnSearch.ClientID %>');
         cntTotalRow=c.rows.length;
//         alert("hi");
         for(var i=1; i<=cntTotalRow-1; i++)
       {
             var cellPivot=c.rows[i].cells[1]
             
             var obj=((c.rows[i].cells[1]).firstChild.checked);
                if(obj==true)
                {
                ((c.rows[i].cells[1]).firstChild.checked=false)
               
                }
                else
                {
                ((c.rows[i].cells[1]).firstChild.checked=true)
                }
           }
          
}
    
    $(document).ready(function(){
        $('#ddlVendor').chosen();
    
    
    });
</script>
<Ajax:ScriptManager ID="ScriptManager1" runat="server"></Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
    <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Consignment Return</b><br />
            <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError"></asp:Label>

        </div>
    <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                               Vendor Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlVendor" runat="server" CssClass="requiredField" ClientIDMode="Static" />
                            </div>
                     <div class="col-md-3">
                            <label class="pull-left">
                               Expiry From
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:TextBox ID="txtFromDate" runat="server"></asp:TextBox>
                            <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                            </div>
                         <div class="col-md-3">
                            <label class="pull-left">
                               Expiry To
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:TextBox ID="txtToDate" runat="server"></asp:TextBox>
                            <cc1:CalendarExtender ID="calTODate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                            </div>
                        <div class="col-md-2">
                            <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton"  Text="Search" OnClick="btnSearch_Click" />
                            </div>
                        </div>
                    </div>
                </div>
        </div>
       
             <div class="POuter_Box_Inventory" style="width:100%;">
              <div class="content" style="text-align:center;width:100%;" >    
     
</div>  
    <div class="Purchaseheader" style="width:100%;">
    Search Result
    </div>
            <asp:GridView ID="consignmentReturnSearch" runat="server" AutoGenerateColumns="False" Width="100%"
            CssClass="GridViewStyle" >
            <Columns>
                <asp:TemplateField HeaderText="S.No" >
                    <ItemStyle CssClass="GridViewLabItemStyle" />
                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                    <ItemTemplate>
                        <%#Container.DataItemIndex+1 %>
                      
                    </ItemTemplate>
                </asp:TemplateField>
                     <asp:TemplateField HeaderText="Select">
                     <HeaderTemplate>
                    <input type="checkbox" id="chkbx" runat="server" title="Select" onclick="cal()" />
                     </HeaderTemplate>
                    <ItemStyle CssClass="GridViewLabItemStyle" />
                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                    <ItemTemplate>
                <asp:CheckBox ID="chkbxReturn" runat="server" />
                <asp:Label ID="lblID" runat="server" Text=' <%#Eval(" ID") %>' Visible="false"></asp:Label> 
                   </ItemTemplate>
                </asp:TemplateField>
                               
                    <asp:TemplateField HeaderText="Consign No">
                    <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Center" />
                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" HorizontalAlign="Center" />
                    <ItemTemplate>
                  <%#Eval("ConsignmentNo")%>   
                   </ItemTemplate>
                </asp:TemplateField>
                               
                <asp:TemplateField HeaderText="Consign Date">
                    <ItemStyle CssClass="GridViewLabItemStyle" />
                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                    <ItemTemplate>
               <%#Eval("PostDate")%>  
                  </ItemTemplate>
                </asp:TemplateField>



                     <asp:TemplateField HeaderText="Expiry Date">
                    <ItemStyle CssClass="GridViewLabItemStyle" />
                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                    <ItemTemplate>
               <%#Eval("MedExpDate")%>  
                  </ItemTemplate>
                </asp:TemplateField>


                               
                <asp:TemplateField HeaderText="ItemName">
                    <ItemStyle CssClass="GridViewLabItemStyle" />
                    <HeaderStyle CssClass="GridViewHeaderStyle" Font-Bold="True" Width="250px" />
                    <ItemTemplate>
              <%#Eval("ItemName")%> 
                     </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Open Qty">
                    <ItemStyle CssClass="GridViewLabItemStyle" />
                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                    <ItemTemplate>
                        <%#Eval("InititalCount")%>
                    </ItemTemplate>
                </asp:TemplateField>
                
                <asp:TemplateField HeaderText="Issued Qty">
                    <ItemStyle CssClass="GridViewLabItemStyle" />
                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                    <ItemTemplate>
                        <%#Eval("ReleasedCount")%>
                    </ItemTemplate>
                </asp:TemplateField>
                
                  <asp:TemplateField HeaderText="Returned Qty">
                    <ItemStyle CssClass="GridViewLabItemStyle" />
                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                    <ItemTemplate>
                        <%#Eval("ReturnedQuantity")%>
                    </ItemTemplate>
                </asp:TemplateField>
                
                <asp:TemplateField HeaderText="Balance Qty">
                    <ItemStyle CssClass="GridViewLabItemStyle" />
                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                    <ItemTemplate>
                      <asp:Label ID="lblavalQty" Text='<%#Eval("BalanceQty")%>' runat="server"></asp:Label>  
                    </ItemTemplate>
                </asp:TemplateField>
                  <asp:TemplateField HeaderText="Return Qty">
                    <ItemStyle CssClass="GridViewLabItemStyle" Width="85px" />
                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="85px" />
                    <ItemTemplate>
                       <asp:TextBox ID="txtReturnQty" Width="50px" runat="server"></asp:TextBox>
                     <cc1:filteredtextboxextender id="FilteredTextBoxExtender1" runat="server" filtertype="Custom, Numbers"
                           targetcontrolid="txtReturnQty" validchars=".">
                                </cc1:filteredtextboxextender>
                       <asp:RangeValidator ID="rv_txtIssueQty" runat="server" Type="Double" ControlToValidate="txtReturnQty" MinimumValue="0" 
                        MaximumValue='<%# Eval("BalanceQty") %>' ErrorMessage="*"></asp:RangeValidator>
                    </ItemTemplate>
                </asp:TemplateField>
                   <asp:TemplateField Visible="false" HeaderText="ExpiryDate">
                    <ItemStyle CssClass="GridViewLabItemStyle" />
                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                    <ItemTemplate>
                     <asp:Label ID="lblExpiryDate" runat="server" Text=' <%#Eval(" MedExpiryDate") %>' Visible="false"></asp:Label> 
                    </ItemTemplate>
                </asp:TemplateField>
                   <asp:TemplateField HeaderText="Reason">
                    <ItemStyle CssClass="GridViewLabItemStyle" />
                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                    <ItemTemplate>
                    <asp:TextBox ID="txtReason" Width="100px" runat="server"></asp:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>
                   <asp:TemplateField HeaderText="GetPassNO">
                    <ItemStyle CssClass="GridViewLabItemStyle" />
                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                    <ItemTemplate>
                      <asp:TextBox ID="txtPassno" Width="100px" runat="server"></asp:TextBox>
                      <asp:Label ID="lblVendorLedgerNo" runat="server" Text=' <%#Eval("VendorLedgerNo") %>' Visible="false" ></asp:Label>
                        <asp:Label ID="lblBatchNumber" runat="server" Text=' <%#Eval("BatchNumber") %>' Visible="false"></asp:Label>
                         <asp:Label ID="lblRate" runat="server" Text=' <%#Eval("Rate") %>' Visible="false"></asp:Label>
                          <asp:Label ID="lblUnitPrice" runat="server" Text=' <%#Eval("UnitPrice") %>' Visible="false"></asp:Label>
                        <asp:Label ID="lblMRP" runat="server" Text=' <%#Eval("MRP") %>' Visible="false"></asp:Label>
                      <asp:Label ID="lblItemID" runat="server" Text=' <%#Eval("ItemID") %>' Visible="false"></asp:Label>
                   <asp:Label ID="lblconsnmntNO" runat="server" Visible="false" Text='<%#Eval("ConsignmentNo") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
       <div class="content" style="text-align:center;" >    
     <asp:Button ID="btnReturn" runat="server" CssClass="ItDoseButton" OnClick="Return_Click" Visible="false" Width="60px" Text="Return"/>
</div>  
    </div> 
</asp:Content> 