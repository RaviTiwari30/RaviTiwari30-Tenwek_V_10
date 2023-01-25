<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="EmailTo_Employee.aspx.cs" Inherits="Design_Email_EmailTo_Employee" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <script type="text/javascript">
         function myFunction(tbindex, inputvalue) {
             var input, filter, table, tr, td, i;
             filter = inputvalue.value.toUpperCase();
             table = document.getElementById("grdEMPEmail");
             tr = table.getElementsByTagName("tr");

             for (i = 0; i < tr.length; i++) {
                 td = tr[i].getElementsByTagName("td")[tbindex];
                 if (td) {
                     if (td.innerHTML.toUpperCase().indexOf(filter) > -1) {
                         tr[i].style.display = "";
                     } else {
                         tr[i].style.display = "none";
                     }
                 }
             }
         }
         function validate() {
             if ($(".chk :checkbox:checked").length == 0) {
                 $("#lblMsg").text('Please Select Doctor');
                 return false;
             }
             if ($.trim($('#txtEmailSubject').val()).length == 0)
             {
                 $("#lblMsg").text('Please Enter the Staff');
                 $('#txtEmailSubject').focus();
                 return false;
             }
             document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
        }
    </script>
    <script type="text/javascript">
        function chkAll(rowID) {
            if ($(rowID).is(':checked')) {
                $('#<%=grdEMPEmail.ClientID%>').find('tr').each(function (row) {
                    if ($(this).closest('tr').find("span[id*=lblEmailID]").text() != "") {
                        $(this).closest('tr').find("input[id*=chkbox]:checkbox").attr("checked", "checked");
                    }
                });
            }
            else {
                $('#<%=grdEMPEmail.ClientID%>').find('tr').each(function (row) {
                    $(this).closest('tr').find("input[id*=chkbox]:checkbox").removeAttr("checked");
                });
            }
        }


    </script>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Email For Employee And Doctor</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
             <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Type</label><b class="pull-right">:</b></div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdbemailType" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="rdbemailType_SelectedIndexChanged" AutoPostBack="true">
                          <asp:ListItem Value="E" Selected="True">Employee</asp:ListItem>
                          <asp:ListItem Value="Doctor">Doctor</asp:ListItem>
                      </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">

                        </div>
                        <div></div>
                    </div></div><div class="col-md-1"></div></div>
                  <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                     <div class="row">
                <div class="col-md-3">
                  <label class="pull-left">Search By Name</label><b class="pull-right">:</b>  
                </div>
                <div class="col-md-19">
                    <input type="text" id="txtSearch" title="Enter Name"  onkeyup="myFunction(1,this)" />
                </div>
                <div style="overflow: auto; padding: 3px; width: 100%; height: 200px;" class="col-md-25">                
                    <asp:GridView ID="grdEMPEmail" runat="server" AutoGenerateColumns="False" OnRowDataBound="grdEMPEmail_RowDataBound" ClientIDMode="Static" Width="100%"
                        CssClass="GridViewStyle">
                        <Columns>
                            <asp:TemplateField HeaderText="Select">
                                <HeaderTemplate>
                                    <asp:CheckBox ID="chkHeader" runat="server" CssClass="chkAll" ClientIDMode="Static" onclick="chkAll(this)" />
                                </HeaderTemplate>
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" HorizontalAlign="Center" />
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkbox" runat="server" CssClass="chk" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Employee Name">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="320px" />
                                <ItemTemplate>
                                    <asp:Label ID="lblEmployee" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Name") %>'></asp:Label>
                                    <asp:Label ID="lblEmployeeID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"EmployeeID") %>' Visible="false"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Email ID">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                <ItemTemplate>
                                    <asp:Label ID="lblEmailID" ClientIDMode="Static" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Email") %>'></asp:Label>

                                </ItemTemplate>
                            </asp:TemplateField>


                        </Columns>
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    </asp:GridView>
                </div>
                <div style="overflow: auto; padding: 3px; width: 100%;" class="row">
                    <div class="col-md-3">
                  <label class="pull-left">Email Subject</label><b class="pull-right">:</b>  
                </div>
                <div class="col-md-19"><asp:TextBox ID="txtEmailSubject" runat="server" Width="100%" ClientIDMode="Static" AutoCompleteType="Disabled" CssClass="requiredField" ></asp:TextBox></div>
                    <div class="row">
                        <div class="col-md-3">
                       <label class="pull-left">Email Body</label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-19">
                         <ckeditor:ckeditorcontrol ID="txtEmailBody" BasePath="~/ckeditor" runat="server"  ClientIDMode="Static"  EnterMode="BR"></ckeditor:ckeditorcontrol>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3"><label class="pull-left">Attachement</label><b class="pull-right">:</b>  </div>
                        <div class="col-md-19"><asp:FileUpload ID="fluemail" runat="server" /></div>
                    </div>
                </div>
            </div>
            </div>   <div class="col-md-1"></div>
                      
                  </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" CssClass="ItDoseButton" OnClientClick="return validate()"></asp:Button>
            </div>
    </div>
</asp:Content>

