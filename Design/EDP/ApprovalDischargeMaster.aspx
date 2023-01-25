<%@ Page  Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="ApprovalDischargeMaster.aspx.cs" Inherits="Design_EDP_ApprovalTypeMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            $('#<%=ddlEmployee.ClientID%>,#<%=ddlDepartment.ClientID%>').chosen();
        });
    </script>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">


            <b>Discharge Report Approval Right master</b>&nbsp;<br />
            <span id="spnErrorMsg" class="ItDoseLblError">
                <asp:Label ID="lblMsg" runat="server" Text=""></asp:Label>

            </span>
      

        </div>
        <div style="width:827px; text-align:center;padding-left:75px; " class="border" >
             <asp:RadioButtonList ID="rbtnChange" Visible="false" runat="server" RepeatDirection="Horizontal" AutoPostBack="true" OnSelectedIndexChanged="rbtnChange_SelectedIndexChanged"><asp:ListItem Text="New" Selected="True" Value="1"></asp:ListItem>
                        
                     </asp:RadioButtonList>
            </div>
        <div class="POuter_Box_Inventory" id="divAdd" runat="server">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Employee
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlEmployee" runat="server" Style="width: 100%" ClientIDMode="Static"></asp:DropDownList>
                            <span style="color: red; font-size: 10px;" class="shat"></span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDepartment" runat="server" ClientIDMode="Static" AutoPostBack="true" OnSelectedIndexChanged="ddlDepartment_SelectedIndexChanged"></asp:DropDownList>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Doctor
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-1">
                            <asp:CheckBox ID="chkAllDoctor" runat="server" Text="All" OnCheckedChanged="chkAllDoctor_CheckedChanged" AutoPostBack="true" />
                        </div>
                        <div class="col-md-17">
                            <div style="overflow:scroll;height:112px; width:772px; text-align: left;border:solid" >
                         <asp:CheckBoxList ID="chkDoctor" runat="server" Height="16px"  RepeatColumns="5" RepeatDirection="Horizontal" CssClass="ItDoseCheckboxlist" Width="542px"></asp:CheckBoxList>
                       </div> 
                        </div>
                        <div class="col-md-3">
                            <asp:CheckBox ID="chkAprove" runat="server" Text="Can Approve" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-10">
                        </div>
                         <div class="col-md-4">
                              <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" CssClass="ItDoseButton" />
                        </div>
                         <div class="col-md-10">
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
       
         <div class="POuter_Box_Inventory" style="text-align: center">
         <div id="DisAppovalOutput" style="max-height: 500px; overflow-x: auto;">
                        </div>
             <input type="button" id="btnUpdate" value="Update" class="ItDoseButton" style="display:none"/>
             </div>
    </div>                    
</asp:Content>

