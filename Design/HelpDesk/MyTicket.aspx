<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MyTicket.aspx.cs" MasterPageFile="~/DefaultHome.master" Inherits="MyTicket" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:content id="content2" contentplaceholderid="contentplaceholder1" runat="server">
<%--<script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>--%>
<script type="text/javascript" src="../../Scripts/Message.js"></script>

      <script type="text/javascript" >
          $(document).ready(function () {
              bindPriority();
          });
          var _PageSize = 20;
          var _PageNo = 0;
          var ticket = "";

          function pageLoad(sender, args) {
              if (!args.get_isPartialLoad()) {
                  $addHandler(document, "keydown", onKeyDown);
              }
          }

          function onKeyDown(e) {
              if (e && e.keyCode == Sys.UI.Key.esc) {
                  if ($find("mpTicketReply")) {
                      closeTicketReply();
                  }
              }
          }
          function closeTicketReply() {
              $("#spnMsg").text("");
              $find("mpTicketReply").hide();
          }
          function searchTicket() {
              $('#lblErrormsg').text('');
              $.ajax({
                  type: "POST",
                  url: "Services/HelpDesk.asmx/ticketSearch",
                  data: '{department:"' + $("#ddlDepartment").val() + '",status:"' + $("#ddlStatus").val() + '",Priority:"' + $("#ddlPriority option:selected").text() + '",TicketNo:"' + $("#txtTicketNo").val() + '"}',
                  dataType: "json",
                  contentType: "application/json;charset=UTF-8",
                  async: false,
                  success: function (response) {
                      ticket = jQuery.parseJSON(response.d);
                      if (ticket != null) {
                          $("#spnTotalRecord").html("Total Record :&nbsp;" + ticket.length);
                          _PageCount = ticket.length / _PageSize;
                          showPage('0');
                      }
                      else {
                          $("#spnTotalRecord").html("");
                          DisplayMsg('MM04', 'lblErrormsg');
                          $('#ticketOutput').hide();
                      }
                  },
                  error: function (xhr, status) {
                      DisplayMsg('MM05', 'lblErrormsg');
                      window.status = status + "\r\n" + xhr.responseText;

                  }

              });
          }
          function showPage(_strPage) {
              _StartIndex = (_strPage * _PageSize);
              _EndIndex = eval(eval(_strPage) + 1) * _PageSize;
              var output = $('#tb_ticket').parseTemplate(ticket);
              $('#ticketOutput').html(output);
              $('#ticketOutput').show();
          }
          function ticketSearchByTr(status) {
              $('#lblErrormsg').text('');
              $.ajax({
                  type: "POST",
                  url: "Services/HelpDesk.asmx/ticketSearchByTr",
                  data: '{department:"' + $("#ddlDepartment").val() + '",status:"' + status + '"}',
                  dataType: "json",
                  contentType: "application/json;charset=UTF-8",
                  async: false,
                  success: function (response) {
                      ticket = jQuery.parseJSON(response.d);
                      if (ticket != null) {
                          $("#spnTotalRecord").html("Total Record :&nbsp;" + ticket.length);
                          _PageCount = ticket.length / _PageSize;
                          showPage('0');
                      }
                      else {
                          $("#spnTotalRecord").html("");
                          DisplayMsg('MM04', 'lblErrormsg');
                          $('#ticketOutput').hide();
                      }
                  },
                  error: function (xhr, status) {
                      DisplayMsg('MM05', 'lblErrormsg');
                      window.status = status + "\r\n" + xhr.responseText;

                  }

              });
          }

          function viewTicket(rowid) {
              var TicketNo = $(rowid).closest('tr').find('#tdTicketNo').text();
              window.open('info.aspx?TicketId=' + TicketNo + '&BackUrl=MyTicket.aspx', '_blank');
              //location.href = 'info.aspx?TicketId=' + TicketNo + '&BackUrl=MyTicket.aspx';
          }

          function bindPriority() {
              $('#lblErrormsg').text('');
              var Priority = $("#ddlPriority");
              $("#ddlPriority option").remove();
              $.ajax({
                  url: "Services/HelpDesk.asmx/bindPriority",
                  data: '{}', // parameter map
                  type: "POST",
                  contentType: "application/json; charset=utf-8",
                  timeout: 120000,
                  async: true,
                  dataType: "json",
                  success: function (result) {
                      var Data = jQuery.parseJSON(result.d);
                      Priority.append($("<option></option>").val("0").html("All"));
                      for (i = 0; i < Data.length; i++) {
                          Priority.append($("<option></option>").val(Data[i].ID).html(Data[i].Name));
                      }
                  },
                  error: function (xhr, status) {
                      DisplayMsg('MM05', 'lblErrormsg');
                      window.status = status + "\r\n" + xhr.responseText;
                  }
              });
          }

          function viewTicketReply(img) {
              var ticketNo = $(img).closest("tr").find("#tdTicketNo").text();

              $.ajax({
                  type: "POST",
                  url: "Services/HelpDesk.asmx/reply_bind",
                  data: '{TicketID:"' + ticketNo + '"}',
                  dataType: "json",
                  contentType: "application/json;charset=UTF-8",
                  async: false,
                  success: function (response) {
                      ticket = jQuery.parseJSON(response.d);
                      if (ticket != null) {
                          $("#lblReplyTicketId").text(ticketNo);
                          var output = $('#scrtTicketReply').parseTemplate(ticket);
                          $('#ticketReplyOutput').html(output);
                          $('#ticketReplyOutput').show();
                      }
                      else {
                          $("#lblReplyTicketId").text("");
                          $("#spnMsg").text("No Reply For Current Ticket");
                          $('#ticketReplyOutput').empty();
                      }
                      $find("mpTicketReply").show();
                  },
                  error: function (xhr, status) {
                      DisplayMsg('MM05', 'lblErrormsg');
                  }
              });
          }
        </script>
    <div id="Pbody_box_inventory">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Ticket Status</b>
            <br />

            <asp:Label ID="lblErrormsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory">
              <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
          Department</label><b class="pull-right">:</b></div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="ddlDepartment" runat="server" ClientIDMode="Static"></asp:DropDownList></div>
                    <div class="col-md-3">
                            <label class="pull-left">Status</label>
                            <b class="pull-right">:</b>
                        </div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="ddlStatus" runat="server"  ClientIDMode="Static">
                            <asp:ListItem Selected="True">All</asp:ListItem>
                            <asp:ListItem Value="0">Pending</asp:ListItem>
                             <asp:ListItem Value="4">Assigned</asp:ListItem>
                            <asp:ListItem Value="1">Process</asp:ListItem>
                            <asp:ListItem Value="2">Close</asp:ListItem>
                              <asp:ListItem Value="5">Forwarded</asp:ListItem>
                            <asp:ListItem Value="3">ReOpen</asp:ListItem>
                        </asp:DropDownList></div>
                        <div class="col-md-3">
                            <label class="pull-left">Priority
                   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlPriority" runat="server"  ClientIDMode="Static"></asp:DropDownList>
                        </div>
                    </div>
                                        
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Ticket No.
                    </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                        <asp:TextBox ID="txtTicketNo" ClientIDMode="Static" runat="server"  MaxLength="3"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbTicket" runat="server" TargetControlID="txtTicketNo" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                        </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                            </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>
                    <div class="col-md-4">
                        
                    </div>
                      <div class="row">
                        <div class="col-md-11"></div>
                          <div class="col-md-2">
                              <input type="button" value="Search" onclick="searchTicket()"  class="ItDoseButton"/>
                          </div>
                        <div class="col-md-11"></div>
                    </div>
                     
        </div>  
                    
            
            
        </div>
             
    </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-22">
                    <div class="row">
                        <div class="pull-left">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: yellow;" class="circle" onclick="ticketSearchByTr(0)"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Pending</b>
                        </div>
                         <div class="pull-left">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: #00cee35c;" class="circle" onclick="ticketSearchByTr(4)"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Assigned</b>
                        </div>
                        <div class="pull-left">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: pink;" class="circle" onclick="ticketSearchByTr(1)"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Processed</b>
                        </div>
                        <div class="pull-left">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left;  background-color: #90ee90;" class="circle" onclick="ticketSearchByTr(2)"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Closed</b>
                        </div>
                        <div class="pull-left">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left;  background-color: #FF99CC;" class="circle" onclick="ticketSearchByTr(3)"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Reopen</b>
                        </div>
                        <div class="pull-left">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left;  background-color: #bec3c59e;" class="circle" onclick="ticketSearchByTr(5)"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Forwarded</b>
                        </div>
                    </div>
                </div>
            </div></div>
    
    <div class="POuter_Box_Inventory">
         <table style="width:100%">
                <tr>
                    <td style="text-align:center"  colspan="5">

                        <div id="ticketOutput" style="max-height: 600px; overflow-x: auto;">
                        </div>

                    </td>

                </tr>
                <tr>
                    <td>
                        <span id="spnTotalRecord"></span>
                    </td>
                </tr>
           </table>
    </div></div>

    <!--Display reply of tickets-->
    <asp:LinkButton ID="btnhide" runat="server" Style="display: none;"></asp:LinkButton>
    <cc1:ModalPopupExtender ID="mpTicketReply" BehaviorID="mpTicketReply" runat="server" CancelControlID="btnReplyCancel"
        DropShadow="true" TargetControlID="btnhide" BackgroundCssClass="filterPupupBackground" PopupControlID="pnlTicketReply" OnCancelScript="closeTicketReply();">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlTicketReply" runat="server" Style="display: none;">
        <div style="margin: 0px; background-color: #eaf3fd; border: solid 1px Green; display: inline-block; padding: 1px 1px 1px 1px; margin: 0px 10px 3px 10px; width: 800px;">
            <div class="Purchaseheader">
                <table width="790">
                    <tr>
                        <td style="text-align: left;">
                            <b>Current Ticket Reply</b>
                        </td>
                        <td style="text-align: right;">
                            <em><span style="font-size: 7.5pt">Press esc or click<img src="../../Images/Delete.gif" style="cursor: pointer" onclick="closeTicketReply()" />to close</span></em>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="width: 797px; text-align: center;">
                <b><span id="spnMsg" class="ItDoseLblError"></span></b>
            </div>
            <div class="POuter_Box_Inventory" style="width: 797px; height: 200px;overflow-x: auto;overflow-y:auto">
                <div id="ticketReplyOutput" style="max-height: 600px; overflow-x: auto;overflow-y:auto"></div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center; width: 797px;">
                 <label id="lblReplyTicketId" style="display:none"></label>

                <input type="button" id="btnSendReplies" onclick="openRestartModel()" value="Reply" />
                <asp:Button ID="btnReplyCancel" runat="server" Text="Close" CssClass="ItDoseButton" />
            </div>
        </div>
    </asp:Panel> 
        <div class="modal fade" id="myModal" style="z-index:10000000000">
            <div class="modal-dialog">

                <!-- Modal content-->
                <div class="modal-content" style="width: 800px">
                    <div class="modal-header">
                        <button type="button" class="close" onclick="$closeRestartModel()" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Reply</h4>
                    </div>
                    <div class="modal-body">
                      
                        <div id="DivOrderDetails" style="max-height: 400px; overflow-y: auto; overflow-x: hidden;">
                        <label id="lblTicketIdToReply" style="display:none"></label>

                            <textarea id="txtDecription" rows="2" cols="10" style="height:100px" placeholder="Enter your reply Here"></textarea>
                        </div>


                    </div>
                    <div class="modal-footer">
                        <input type="button" id="btnSendReply"  value="Send" onclick="replyTicket()" />
                    </div>
                </div>

            </div>
        </div>
    

            <div class="modal fade" id="myModelViewStatus" >
            <div class="modal-dialog">

                <!-- Modal content-->
                <div class="modal-content" style="width: 800px">
                    <div class="modal-header">
                        <button type="button" class="close" onclick="$closeModelViewStatus()" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Forwarded Status</h4>
                    </div>
                    <div class="modal-body">
                      
                           <div class="row" id="Div2" style="max-height: 400px; overflow-y: auto; overflow-x: hidden;">
                        
                             <table class="FixedHeader" id="tblItemDetails" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">Ticket Id</th> 
                                <th class="GridViewHeaderStyle" style="width: 100px;">Status</th>   
                                 <th class="GridViewHeaderStyle" style="width: 100px;">View Reply</th>                                 
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>

                          </div>
                    </div>
                    <div class="modal-footer">
                         
                    </div>
                </div>

            </div>
                </div>
       
     

    <script id="tb_ticket" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdticket"
    style="width:99%;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Ticket No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Error Type</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Priority</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Status</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:220px;  ">Start Date Time</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:200px;  ">End Date Time</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:200px;  ">Down Time</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:180px;  ">Last Update</th>	
               <th class="GridViewHeaderStyle" scope="col" style="width:300px;">Assign To</th>		
                              <th class="GridViewHeaderStyle" scope="col" style="width:300px;">Forwarded To/Ticket No</th>	 
            <%--<th class="GridViewHeaderStyle" scope="col" style="width:30px;">View</th> --%>   
             <th class="GridViewHeaderStyle" scope="col" style="width:30px;">View Reply</th>   
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Print</th>          
		</tr>
        <#       
        var dataLength=ticket.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        if(_EndIndex>dataLength)
            {           
               _EndIndex=dataLength;
            }
        for(var j=_StartIndex;j<_EndIndex;j++)
            {       
        objRow = ticket[j];
        #>
            

                    <tr id="<#=j+1#>" style="<#if(objRow.Status=="Pending"){#>
                                        background-color:yellow"   
                                     <#}else if(objRow.Status=="Process"){#>
                                        background-color:pink"
                                     <#}else if(objRow.Status=="ReOpen"){#>
                                        background-color:#FF99CC"
                                     <#}else if(objRow.Status=="Assigned"){#>
                                        background-color:#00cee35c"
                                     <#}else if(objRow.Status=="Forworded"){#>
                                        background-color:#bec3c59e"
                                     <#}else{#>
                                        background-color:LightGreen"
                                     <#}#> >                  
                    <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdTicketNo"  style="width:80px;text-align:center" ><#=objRow.TicketNo#></td>
                         <td class="GridViewLabItemStyle" id="tdErrorType"  style="width:80px;text-align:center" ><#=objRow.ErrorType#></td>
                    <td class="GridViewLabItemStyle" id="tdPriority"  style="width:100px;text-align:center" ><#=objRow.Priority#></td>
                    <td class="GridViewLabItemStyle" id="tdStatus"  style="width:90px;" ><#=objRow.Status#></td>
                    <td class="GridViewLabItemStyle" id="tdProblemStartTime" style="width:200px;"><#=objRow.ProblemStartTime#></td>
                    <td class="GridViewLabItemStyle" id="tdProblemEndTime" style="width:200px;"><#=objRow.ProblemEndTime#></td>

                         <td class="GridViewLabItemStyle" id="tdDownTime" style="width:200px;"><#=objRow.DownTime#></td>
                        <td class="GridViewLabItemStyle" id="tdLastUpdate" style="width:200px;"><#=objRow.LastUpdate#></td>
                         <td class="GridViewLabItemStyle" id="tdAssignedEngineer" style="width:200px;"><#=objRow.Assigned_Engineer#></td>
                           <td class="GridViewLabItemStyle" id="tdForwordedTicketNo" style="display:none"><#=objRow.ForwordedTicketNo#></td> 
                 <td class="GridViewLabItemStyle" id="tdForworded" style="color:blue;font-weight: bolder;" onclick="<#if(objRow.ForwordedTicketNo!=""){#>openModelViewStatus(this)"<#}#>" > <#=objRow.ForwordTo#></td>
                
                
                
                    <%--<td class="GridViewLabItemStyle" style="width:30px; text-align:right;">
                                                                                                                 
                       <img id="imgView" src="../../Images/view.GIF" style="cursor:pointer" onclick="viewTicket(this)" />
                    </td> --%> 
                    <td class="GridViewLabItemStyle" style="width:30px; text-align:center;">                                                                                                                                      
                    <img id="img1" src="../../Images/view.GIF" style="cursor:pointer" onclick="viewTicketReply(this)" title="Click To View Reply"/>                          
                    </td> 
                   <td class="GridViewLabItemStyle" style="width:30px; text-align:center;">                                                                                                                                      
                    <img id="img2" src="../../Images/print.GIF" style="cursor:pointer" onclick="PrintReport(this)" title="Click To Print"/>                          
                    </td> 
                                           
                    </tr>            
        <#}        
        #>      
     </table>   
             <table>
       <tr>
    
     <#for(var j=0;j<_PageCount;j++){ #>
     <td><a href="javascript:void(0);" onclick="showPage('<#=j#>');" ><#=j+1#></a></td>
     <#}#>         
   
     </tr>
     
     </table>  
    </script>


     <script id="scrtTicketReply" type="text/html">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" style="width:780px;border-collapse:collapse;">
            <tr id="Tr1">
                <th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
                  <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Ticket No</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Reply Date Time</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:300px;">Description</th>  
                 <th class="GridViewHeaderStyle" scope="col" style="width:300px;">Reply From</th> 
              <%--  <th class="GridViewHeaderStyle" scope="col" style="width:300px;">Action</th> --%>
            </tr>
            <#       
                var dataLength=ticket.length;
                window.status="Total Records Found :"+ dataLength;
                var objRow;   
                for(var j=0;j<dataLength;j++)
                {       
                    objRow = ticket[j];
            #>
            <tr id="Tr2">                            
                <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
                <td class="GridViewLabItemStyle" id="tdTicketID"  style="width:120px;text-align:left" ><#=objRow.TicketID#></td>
                 <td class="GridViewLabItemStyle" id="tdName"  style="width:120px;text-align:left" ><#=objRow.Name#></td>
               
                 <td class="GridViewLabItemStyle" id="tdReply_Time"  style="width:140px;text-align:center" ><#=objRow.REPLY_TIME#></td>
                <td class="GridViewLabItemStyle" id="tdDescription1"  style="width:300px;text-align:left" ><#=objRow.DESCRIPTION#></td>
             <td class="GridViewLabItemStyle" id="tdReplyFromName"  style="width:120px;text-align:left" ><#=objRow.ReplyFromName#></td>
                <%-- <td class="GridViewLabItemStyle" id="tdReply"  style="width:120px;text-align:left" >
                     <input type="button" id="btnOpenmodelReply" onclick="openRestartModel(this)"  value="Reply"/>
                 </td>--%>
                </tr>            
            <#}#>      
        </table>    
    </script>

           <script type="text/javascript">
               var openRestartModel = function () {

                   var TicketID = $("#lblReplyTicketId").text();//$(id).closest('tr').find("#tdTicketID").text();
                   $("#lblTicketIdToReply").text(TicketID);
                   $("#myModal").showModel();
               }

               var $closeRestartModel = function () {
                   $("#lblTicketIdToReply").text();
                   $("#myModal").hideModel();

               }


               function replyTicket() {
                   var TicketId = $("#lblTicketIdToReply").text();
                   if ($("#txtDecription").val() != "" && TicketId != "") {
                       $.ajax({
                           type: "POST",
                           url: "Services/HelpDesk.asmx/ReplyTicket",
                           data: '{status:"Pending",Description:"' + $("#txtDecription").val() + '",TicketId:"' + TicketId + '"}',
                           dataType: "json",
                           contentType: "application/json;charset=UTF-8",
                           async: false,
                           success: function (response) {
                               ticket = response.d;
                               if (ticket == "1") {
                                   DisplayMsg('MM01', 'lblErrormsg');
                                   $("#txtDecription").val('')
                                   ViewUpdatedReply(TicketId)
                                   $closeRestartModel();
                               }
                               else {
                                   DisplayMsg('MM05', 'lblErrormsg');
                               }

                           },
                           error: function (xhr, status) {
                               DisplayMsg('MM05', 'lblErrormsg');
                               window.status = status + "\r\n" + xhr.responseText;
                           }
                       });
                   }
                   else {
                       $("#lblErrormsg").text('Please Enter Description');
                       $("#txtDecription").focus();
                   }
               }

               function ViewUpdatedReply(ticketNo) {
                   $.ajax({
                       type: "POST",
                       url: "Services/HelpDesk.asmx/reply_bind",
                       data: '{TicketID:"' + ticketNo + '"}',
                       dataType: "json",
                       contentType: "application/json;charset=UTF-8",
                       async: false,
                       success: function (response) {
                           ticket = jQuery.parseJSON(response.d);
                           if (ticket != null) {
                               var output = $('#scrtTicketReply').parseTemplate(ticket);
                               $('#ticketReplyOutput').html(output);
                               $('#ticketReplyOutput').show();
                           }
                           else {
                               $("#spnMsg").text("No Reply For Current Ticket");
                               $('#ticketReplyOutput').empty();
                           }
                           $find("mpTicketReply").show();
                       },
                       error: function (xhr, status) {
                           DisplayMsg('MM05', 'lblErrormsg');
                       }
                   });
               }




               var openModelViewStatus = function (id) {
                   var TicketID = $(id).closest('tr').find("#tdForwordedTicketNo").text();
                   BindStatus(TicketID);
                   $("#myModelViewStatus").showModel();
               }

               var $closeModelViewStatus = function () {
                   $("#lblTicketIdToReply").text();
                   $("#myModelViewStatus").hideModel();

               }


               function BindStatus(TickId) {
                   serverCall('Services/HelpDesk.asmx/BindStatus', { TickId: TickId }, function (response) {
                       var responseData = JSON.parse(response);
                       if (responseData.status) {
                           $('#tblItemDetails tbody').empty();
                           data = responseData.data;
                           $.each(data, function (i, item) {

                               var Color = "";

                               if (item.Status == "Pending") {
                                   Color = "background-color:yellow";
                               } else if (item.Status == "Process") {
                                   Color = "background-color:pink";
                               } else if (item.Status == "ReOpen") {
                                   Color = " background-color:#FF99CC";
                               } else if (item.Status == "Assigned") {
                                   Color = " background-color:#00cee35c"
                               } else if (item.Status == "Forworded") {
                                   Coloe = " background-color:#bec3c59e"
                               } else {
                                   Color = "background-color:LightGreen";
                               }


                               var j = i + 1;
                               var row = '<tr Style=' + Color + '>';
                               row += '<td id="tdsno"  class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                               row += '<td  id="tdTicketNo" class="GridViewLabItemStyle" >' + item.TicketID + '</td>';
                               row += '<td  id="tdQty" class="GridViewLabItemStyle" style="text-align: center;">' + item.Status + '</td>';
                               row += '<td  id="tdQty" class="GridViewLabItemStyle" style="text-align: center;"><img id="img1" src="../../Images/view.GIF" style="cursor:pointer" onclick="viewTicketReply(this)" title="Click To View Reply"/></td>';

                               row += '</tr>';
                               $('#tblItemDetails tbody').append(row);

                           });


                       }

                   });
               }


               function PrintReport(id) {
                   var TicketID = $(id).closest('tr').find("#tdTicketNo").text();
                   var ForwordedTicketID = $(id).closest('tr').find("#tdForwordedTicketNo").text();

                   if (ForwordedTicketID == "")
                       ForwordedTicketID = 0;
                  
                   serverCall('Services/HelpDesk.asmx/PrintReport', { TickId: TicketID, FTickId: ForwordedTicketID }, function (response) {
                        var responseData = JSON.parse(response);
                       if (responseData.status) {
                           window.open(responseData.data);
                       } else {
                           modelAlert(responseData.data);
                       }

                   });



               }

        </script>
</asp:content>

