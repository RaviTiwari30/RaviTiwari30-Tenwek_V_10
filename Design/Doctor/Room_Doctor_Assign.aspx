<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Room_Doctor_Assign.aspx.cs" Inherits="Design_OPD_Room_Doctor_Assign" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#<%=ddlDept.ClientID %>").chosen();
            //$("#ctl00_ContentPlaceHolder1_rpRoomDoctor_ctl01_ddlDoctor").chosen();
         
        });
        function checkPatients(rdid) {
            //var rdid = $(id).closest('tr').find('.RId').text();
            //alert(rdid);
                $.ajax({
                    type: "POST",
                    data: JSON.stringify({ RoomDoctorID: rdid }),
                    url: "Room_Doctor_Assign.aspx/CheckPatients",
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    timeout: 120000,
                    async: false,
                    success: function (result) {
                        var rs = (result.d);
                        if (rs != "0") {
                            
                            $("#spanSelect").text('Y');
                        }
                        else {
                            $("#spanSelect").text('N');

                        }
                    },
                    error: function (xhr, status) {
                        $("#spanSelect").text('E');

                                           }

                });
            
        }
        function checkDoctor(id)
        {
            var selectedDocId = $(id).val();
           var spanid= $(id).closest('tr').find(".spanId").text();
           jQuery("tr.TableRow").each(function () {
               var docid = $(this).find(".DoctorId").val();
               var spanid1 = $(this).find(".spanId").text();
                
               //alert(id+'-'+$(this).find(".DoctorId"));
               if (spanid != spanid1) {
                       if (selectedDocId != "--Select Doctor--") {
                           if (selectedDocId == docid) {
                               alert("Same doctor can not assigned in different rooms.");
                               location.reload();
                               return;
                           }
                       }
                   
               }
            });

        }
        function RoomDoctor()
        {
            var isselect = false;
            var data = new Array();
            var Obj = new Object();
            jQuery("#tblRoomDoctor tr").each(function () {
                var id = jQuery(this).attr("id");

                var $rowid = jQuery(this).closest("tr");
                if ((id != "Header") || (id != "trTA") || (id != "trTB") || (id != "undefined") || (id != "")) {
                    if ($rowid.find("#chkSelect").is(':checked') == true) {
                        Obj.Id = $rowid.find("span[id*=spanId]").text();
                        //alert(Obj.Id);
                        
                        Obj.RoomId = $rowid.find("span[id*=spanRoomId]").text();
                        Obj.DoctorId = $rowid.find("select").val();
                        if (Obj.DoctorId == "--Select Doctor--") {
                            checkPatients(Obj.Id);
                            var rs = $("#spanSelect").text();

                            if (rs == 'Y') {
                                alert("Doctor has asssigned patients. Please remove them first.");

                                
                            }
                        }
                        data.push(Obj);
                        Obj = new Object();
                    }
                }

            });
            
            return data;
        }
        function saveRoomDoctor() {
            var result = RoomDoctor();
            var rs = $("#spanSelect").text();
            if (rs == 'Y')
                return false;
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
                             if (rs == "2") {
                                 $("#lblMsg").text('One doctor cannot assigned in two room.');
                                 //bindIntake();
                             }
                             else {
                                 $("#lblMsg").text('Error occurred, Please contact administrator');
                                 // bindIntake();
                             }
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
     <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Room Doctor Details</b><br />
                <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError"></asp:Label>
         <span id="spanSelect" style="display:none;"></span>
            </div>
           
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">
                
                  
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
                                                  </div>
                        <div class="col-md-5">
                             </div>
                      <div class="col-md-8">
                       
                      </div>
                        
</div>
            </div>
    <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Assign Doctor
                </div>
        </div>
            
    <div class="POuter_Box_Inventory">
     <asp:Repeater ID="rpRoomDoctor" runat="server" OnItemDataBound="rpRoomDoctor_ItemDataBound">
                                            <HeaderTemplate>
                                                <table id="tblRoomDoctor" cellspacing="0" border="1" style="border:0px; width: 100%;">
                                                    <tr  id="Header" style="text-align: center;">
                                                    
                                                    <th >
                                                       Room No
                                                    </th>
                                                    <th>
                                                        Doctor
                                                    </th>
                                                        <th></th>
                                                </tr>
                                                
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <tr style="text-align: center;" class="TableRow">
                                                    
                                                    <td >
                                                       <span id="spanId" class="spanId"  style="display:none;"> <%# Eval("RId") %></span>
                                                       <span id="spanRoomId" runat="server"  style="display:none;"> <%# Eval("ID") %></span>
                                                        <%# Eval("RoomNo") %>
                                                    </td>
                                                    <td> 
                                                        <asp:DropDownList ID="ddlDoctor" CssClass="DoctorId" runat="server" Width="350px" TabIndex="2" onchange="checkDoctor(this);" AutoPostBack="false" OnSelectedIndexChanged="ddlDoctor_SelectedIndexChanged"
                                                                ToolTip="Select Doctor">
                                                            </asp:DropDownList>
                                                    </td>
                                                    <td    style="width:80px;text-align:left" ><input type="checkbox" id="chkSelect" 
                                                        /></td> 
                                                </tr>
                                                                                           </ItemTemplate>
                                            <FooterTemplate>
                                                </table>
                                            </FooterTemplate>
                                        </asp:Repeater>
                                    
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
                          <input id="btnSave" type="button" value="Save" class="ItDoseButton" onclick="saveRoomDoctor()" />
           
                      </div>
                            </div>
       </div>                 


</asp:Content>
