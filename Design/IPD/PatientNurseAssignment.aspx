<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PatientNurseAssignment.aspx.cs" Inherits="Design_IPD_PatientNurseAssignment" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
       <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <form id="form1" runat="server">
   <div id="Pbody_box_inventory">
       
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>&nbsp; Nurse Assignment</b><br />
            <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError" />

        </div>
     
        <asp:Panel  runat="server" ID="pnlRoomType">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Nurse Assignment&nbsp;
                </div>
                 <div class="POuter_Box_Inventory" style="text-align: center">
                      <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Room Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:DropDownList ID="ddlCaseType" ClientIDMode="Static" runat="server" TabIndex="1" ToolTip="Select Room Type"></asp:DropDownList>
                        </div>
                       
                         <div class="col-md-3">
                            <label>
                              Floor
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:DropDownList ID="cmbFloor" runat="server" ToolTip="Select Floor" TabIndex="2"> </asp:DropDownList>
                        </div>
                         
                        <div class="col-md-3">
<asp:Button ID="btnSubmit" runat="server" OnClick="btnSubmit_Click" Text="Search" ToolTip="Click For Search " TabIndex="3" CssClass="ItDoseButton"  />
                        </div>
                        <div class="col-md-4">
                        </div>
                    </div>
                               
                </div>
                <div class="col-md-1"><asp:Label runat="server" ID="lblTransactionNo" Text="" Visible="false"></asp:Label></div>
            </div>
                 </div>
                 <div class="POuter_Box_Inventory" style="text-align: center">
                      <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Nurse Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                            <asp:DropDownList ID="ddlAvailNurse" runat="server" Width="250px" />
                            <span class="shat" style="color: red; font-size: 10px;">*</span>
                        </div>
                        
                        <div class="col-md-5">
                             <asp:Button ID="btnsave" runat="server" OnClick="btnsave_Click" Text="Save" ToolTip="Click For Save " TabIndex="5" CssClass="ItDoseButton" />            
                        </div>
                         <div class="col-md-2">
                            
                        </div>
                        </div>
                    </div>
           
        </div></div>
                <asp:GridView ID="grdInv" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                    PageSize="5" Width="100%" OnRowDataBound="grdInv_RowDataBound">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField>
                            <HeaderTemplate>S.No.<asp:CheckBox ID="chkHeader" runat="server" CssClass="pull-right" /></HeaderTemplate>
                            <ItemTemplate>
                                <span style="text-align: center"> <%# Container.DataItemIndex+1 %></span>
                               <asp:Label runat="server" ID="TransactionID" Text='<%#Eval("TransactionID")%>' Visible="false"></asp:Label>  
                                <asp:CheckBox ID="chkRow" runat="server" CssClass="pull-right" />
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                           <asp:TemplateField HeaderText="IPD No">
                            <ItemTemplate>
                             <asp:Label runat="server" ID="IPDNo" Text='<%#Eval("IPDNo")%>' ></asp:Label>  
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="75px" />
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="Patient Name">
                            <ItemTemplate>
                             <asp:Label runat="server" ID="PName" Text='<%#Eval("PName")%>' ></asp:Label>  
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="200px" />
                        </asp:TemplateField>
                       
                        <asp:TemplateField HeaderText="Room Type">
                            <ItemTemplate>
                                 <asp:Label runat="server" ID="room_type" Text='<%#Eval("RoomType")%>' ></asp:Label>
                                 <asp:Label runat="server" ID="lblIPDCaseTypeID" Visible="false" Text='<%#Eval("IPDCaseTypeID")%>' ></asp:Label>
                                

                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="200px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Room Name">
                            <ItemTemplate>
                                 <asp:Label runat="server" ID="RoomName" Text='<%#Eval("RoomName")%>' ></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="100px" />
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="Nurse Name">
                            <ItemTemplate>
                             <asp:Label runat="server" ID="NurseName" Text='<%#Eval("NurseName")%>' ></asp:Label>  
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Assigned On">
                            <ItemTemplate>
                               <asp:Label runat="server" ID="AssignmentDateIN" Text='<%#Eval("AssignmentDateIN")%>' ></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Completed On">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="AssignmentDateOUT" Text='<%#Eval("AssignmentDateOUT")%>' ></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>                       
                       
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="STATUS" Text='<%#Eval("STATUS")%>' ></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                     
                       
                       
                    </Columns>
                </asp:GridView>
            </div>
        </asp:Panel>
         <script type="text/javascript">
             $("[id*=chkHeader]").live("click", function () {
                 var chkHeader = $(this);
                 var grid = $(this).closest("table");
                 $("input[type=checkbox]", grid).each(function () {
                     if (chkHeader.is(":checked")) {
                         $(this).attr("checked", "checked");
                         $("td", $(this).closest("tr")).addClass("selected");
                     } else {
                         $(this).removeAttr("checked");
                         $("td", $(this).closest("tr")).removeClass("selected");
                     }
                 });
             });
             $("[id*=chkRow]").live("click", function () {
                 var grid = $(this).closest("table");
                 var chkHeader = $("[id*=chkHeader]", grid);
                 if (!$(this).is(":checked")) {
                     $("td", $(this).closest("tr")).removeClass("selected");
                     chkHeader.removeAttr("checked");
                 } else {
                     $("td", $(this).closest("tr")).addClass("selected");
                     if ($("[id*=chkRow]", grid).length == $("[id*=chkRow]:checked", grid).length) {
                         chkHeader.attr("checked", "checked");
                     }
                 }
             });
</script>
    </div>
    </form>
</body>
</html>
