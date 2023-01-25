<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="doctorPatientAssign.aspx.cs" Inherits="Design_OPD_doctorPatientAssign" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style>
        table {
  border-collapse: collapse;
  width: 100%;
}

th, td {
  text-align: left;
  padding: 8px;
}


tr:nth-child(even) {background-color: #f2f2f2;}
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#<%=ddlDept.ClientID %>").chosen();
              //$("#ctl00_ContentPlaceHolder1_rpRoomDoctor_ctl01_ddlDoctor").chosen();
            var x = setInterval("reloadPage()", 30000);
        });
        
        function reloadPage() {
          //  location.reload();
        }
        function assignDoctor(id)
        {
            //alert($(id).closest('tr').find('.DoctorId').val());
            var pid = $(id).closest('tr').find('.PatientId').text();
            var docid = $(id).closest('tr').find('.DoctorId').val();
            var Appid = $(id).closest('tr').find('.appid').text();
            var Date = $('#ucFromDate').val();
            $.ajax({
                type: "POST",
                data: JSON.stringify({ DoctorId: docid, PatientId: pid, Date: Date, Appid: Appid }),
                url: "doctorPatientAssign.aspx/assignDoctorPatient",
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                timeout: 120000,
                async: false,
                success: function (result) {
                    var rs = (result.d);
                    if (rs == "1") {
                        $("#lblMsg").text('Record Saved Successfully');
                        //bindIntake();
                    }
                    else {
                        $("#lblMsg").text('Error occurred, Please contact administrator');
                        // bindIntake();
                    }
                    location.reload();
                    $('#btnSave').removeProp('disabled');
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    $("#lblMsg").text('Error occurred, Please contact administrator');
                    $('#btnSave').removeProp('disabled');
                }

            });
            
        }
        function RoomDoctor() {
            var data = new Array();
            var Obj = new Object();
            jQuery("#tblRoomDoctor tr").each(function () {
                var id = jQuery(this).attr("id");

                var $rowid = jQuery(this).closest("tr");
                if ((id != "Header") || (id != "trTA") || (id != "trTB") || (id != "undefined") || (id != "")) {
                    if ($rowid.find("#chkSelect").is(':checked') == true) {
                        Obj.Id = $rowid.find("span[id*=spanId]").text();
                        Obj.RoomId = $rowid.find("span[id*=spanRoomId]").text();
                        Obj.DoctorId = $rowid.find("select").val();
                        data.push(Obj);
                        Obj = new Object();
                    }
                }

            });
            return data;
        }
        function saveRoomDoctor() {
            var result = RoomDoctor();
            if (result != "") {
                $.ajax({
                    type: "POST",
                    data: JSON.stringify({ RoomDoctor: result }),
                    url: "Room_Doctor_Assign.aspx/saveRoomDoctor",
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    timeout: 120000,
                    async: false,
                    success: function (result) {
                        var rs = (result.d);
                        if (rs == "1") {
                            $("#lblMsg").text('Record Saved Successfully');
                            //bindIntake();
                        }
                        else {
                            $("#lblMsg").text('Error occurred, Please contact administrator');
                            // bindIntake();
                        }
                        $('#btnSave').removeProp('disabled');
                    },
                    error: function (xhr, status) {
                        window.status = status + "\r\n" + xhr.responseText;
                        $("#lblMsg").text('Error occurred, Please contact administrator');
                        $('#btnSave').removeProp('disabled');
                    }

                });
            }
            else
                $("#lblMsg").text('Please Select At Least One CheckBox');

        }




    </script>
  <br />
    <br />
    <br />
    <div class="POuter_Box_Inventory" style="text-align: center;">
        <b>Assign  Doctor Patient</b><br />
        <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError"></asp:Label>
    </div>

    <div class="POuter_Box_Inventory" style="text-align: center">
        <div class="row">

            <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

            <div class="col-md-3">
                <label class="pull-left">
                    Clinic
                </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-5">
                <asp:DropDownList ID="ddlDept" runat="server" TabIndex="2" AutoPostBack="true" OnSelectedIndexChanged="ddlDept_SelectedIndexChanged"
                    ToolTip="Select Department">
                </asp:DropDownList>
            </div>

            <div class="col-md-3">
                <label class="pull-left">Date</label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-5">
                <asp:TextBox ID="ucFromDate" runat="server" ToolTip="Click To Select From Date" ClientIDMode="Static" TabIndex="1" AutoPostBack="true" OnTextChanged="ddlDept_SelectedIndexChanged" ></asp:TextBox>
                <cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
            </div>
            <div class="col-md-8">
            </div>

        </div>
    </div>
    <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Assign Doctor Patient
                </div>
        </div>
            
    <div class="POuter_Box_Inventory">
        <table style="width:100%;">
            <tr>
                <td style="width:150px;vertical-align:top;">
                    <div style="background-color:#ced4d6;height:70px;vertical-align:top;text-align:center;" runat="server" id="divSelf">
                            
                        <asp:Label ID="lblRoomNo"   runat="server" /><br />
                        <asp:Label ID="lblDoctorName"   runat="server" />
                        </div>
                    <asp:Repeater ID="rpSelf" runat="server"  OnItemDataBound="rpSelf_ItemDataBound">
                                           <HeaderTemplate>
                                                                <table class="tbl" cellspacing="0" style="border-collapse: collapse; ">
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <tr>
                                                                    <td class="GridViewStyle" style="color: #800080; text-align: left; vertical-align :top; background-color: transparent; width: 150px;">
                                                                     
                                                         <%--<asp:Label ID="lblPatientId" CssClass="PatientId" Font-Bold="true" Visible="false" runat="server" Text='<%# Eval("PatientId") %>' />
                                                         --%>
                                                                        <span id="spanpid" class="PatientId"><%# Eval("PatientID") %></span>                <%# Eval("PName") %> 
                                                                        <span id="spnappid" class="appid"><%# Eval("App_ID") %></span>                <%# Eval("App_ID") %> 
                                                                        <br />
                                                                        <span id="spanTriage" title="Triage Status:" style="color: white; background-color: <%# Eval("ColorCode") %>"> <%# Eval("CodeType") %> </span>
                                                                    <br />
                                                                        <asp:DropDownList CssClass="DoctorId"  ID="ddlDoctorList" Width="150" runat="server" TabIndex="2" AutoPostBack="false" onchange="assignDoctor(this);" OnSelectedIndexChanged="ddlDoctorList_SelectedIndexChanged"
                                                                ToolTip="Select Doctor">
                                                            </asp:DropDownList>
                                                    
                                                                    </td>
                                                                   
                                                                </tr>
                                                            </ItemTemplate>
                                                            <FooterTemplate>
                                                                </table>
                                                            </FooterTemplate>
        </asp:Repeater></td>
                <td style="vertical-align:top;">
                    <asp:Repeater ID="rpRoomDoctor" runat="server" OnItemDataBound="rpRoomDoctor_ItemDataBound">
                                            <HeaderTemplate>
                                                <table id="tblRoomDoctor" cellspacing="0" border="1" style="border:0px; width: 1050px;">
                                                    <tr style="text-align: center;">
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                    <td style="vertical-align:top;">
                                                        <div style="background-color:#ced4d6;height:70px;text-align:center;">
                                                                                                                    <span id="spanId" style="display:none" ><%# Eval("ID") %></span><br />
                                                        <%# Eval("RoomNo") %><br />
                                                         <asp:Label ID="lblDoctorId" Font-Bold="true" Visible="false" runat="server" Text='<%# Eval("Doctor_Id")%>' />
                                                        <span id="spanDoctorId"  style="display:none;"><%# Eval("Doctor_Id") %></span>
                                                        <span id="spanDoctorName" ><%# Eval("DoctorName") %></span>
                                                            </div>

                                                        <asp:Repeater ID="rpPatient" runat="server" OnItemDataBound="rpPatient_ItemDataBound">
                                                            <HeaderTemplate>
                                                                <table class="tbl" cellspacing="0" style="border-collapse: collapse; width: 100%;">
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <tr>
                                                                    <td class="GridViewStyle" style="color: #800080; text-align: left; background-color: transparent; width: 150px;">
                                                                         <span id="spanpid" class="PatientId"><%# Eval("PatientID") %></span>   <%# Eval("PName") %><br />
                                                                          <span id="spnappid" class="appid"><%# Eval("App_ID") %></span>                <%# Eval("App_ID") %> 
                                                                        <asp:DropDownList ID="ddlDoctor" runat="server" Width="150"  TabIndex="2" AutoPostBack="false" CssClass="DoctorId"   onchange="assignDoctor(this);"  OnSelectedIndexChanged="ddlDoctor_SelectedIndexChanged"
                                                                ToolTip="Select Doctor">
                                                            </asp:DropDownList>
                                                    
                                                                    </td>
                                                                   
                                                                </tr>
                                                            </ItemTemplate>
                                                            <FooterTemplate>
                                                                </table>
                                                            </FooterTemplate>
                                                        </asp:Repeater>

                                                    </td>

                                             </ItemTemplate>
                                            <FooterTemplate>
                                                 </tr>
                                                </table>
                                            </FooterTemplate>
                                        </asp:Repeater>
                </td>
            </tr>
        </table>
         
    
     
                                    
        </div>
    
    <div class="POuter_Box_Inventory">
        
    <div class="row">
                
                  
     <div class="col-md-3">
                            </div>
                        <div class="col-md-5">
                            </div>
                
                  <div class="col-md-3">
                                                  </div>
                        <div class="col-md-5">
                             </div>
                      <div class="col-md-8"> 
                          <%--<input type="button" value="Save" class="ItDoseButton" onclick="" />--%>
           
                      </div>
                            </div>
       </div>                 


</asp:Content>


